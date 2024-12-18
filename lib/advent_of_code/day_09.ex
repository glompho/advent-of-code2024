defmodule AdventOfCode.Day09 do
  def zip2(lists) do
    max_len = lists |> Enum.map(&length(&1)) |> Enum.max()

    lists
    |> Enum.map(&(&1 ++ List.duplicate(nil, max_len - length(&1))))
    |> Enum.zip()
    |> Enum.map(&(&1 |> Tuple.to_list() |> Enum.reject(fn x -> x == nil end)))
  end

  def part1(args) do
    list =
      String.graphemes(String.trim(args))
      |> Enum.map(&String.to_integer/1)

    spaces =
      Enum.take_every(tl(list), 2)
      |> Enum.with_index()

    data =
      Enum.take_every(list, 2)
      |> Enum.with_index()
      |> Enum.reverse()
      |> Enum.flat_map(fn {size, id} ->
        List.duplicate(id, size)
      end)

    {unpacked_data, packed_data} =
      Enum.reduce(spaces, {data, []}, fn {space_size, index}, {remaining_data, acc} ->
        if index < hd(remaining_data) do
          {packed, remaining} = Enum.split(remaining_data, space_size)
          {remaining, [packed | acc]}
        else
          {remaining_data, acc}
        end
      end)

    grouped_data =
      unpacked_data
      |> Enum.chunk_by(& &1)
      |> Enum.reverse()

    zip2([grouped_data, Enum.reverse(packed_data)])
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.map(fn {x, index} -> x * index end)
    |> Enum.sum()
  end

  def insert_piece({data_size, data_index}, {space_size, space_index, space_content}) do
    {space_size - data_size, space_index,
     space_content ++
       [{data_size, data_index}]}
  end

  def can_fit?(piece, space) do
    {space_size, space_index, _space_content} = space
    {data_size, data_index} = piece
    space_index < data_index and space_size >= data_size
  end

  def pack(piece, spaces) do
    Enum.reduce(spaces, {[], false}, fn space, {acc, placed} ->
      if not placed and can_fit?(piece, space) do
        {acc ++ [insert_piece(piece, space)], true}
      else
        {acc ++ [space], placed}
      end
    end)
  end

  def pack_pieces(spaces, pieces) do
    Enum.reduce(pieces, {spaces, []}, fn piece, {spaces, unfitted} ->
      {updated_spaces, packed} = pack(piece, spaces)

      if packed do
        {data_size, data_index} = piece

        {List.insert_at(updated_spaces, data_index, {0, data_index - 0.5, [{data_size, 0}]}),
         unfitted}
      else
        {spaces, [piece | unfitted]}
      end
    end)
  end

  def part2_old(args) do
    list = String.graphemes(String.trim(args))

    spaces =
      Enum.take_every(tl(list), 2)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {size, index} ->
        {size, index, _contents = []}
      end)

    pieces =
      Enum.take_every(list, 2)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.reverse()

    # IO.inspect(data)
    # IO.inspect(spaces)

    {filled_spaces, unfitted} =
      pack_pieces(spaces, pieces)

    final_spaces =
      filled_spaces
      |> Enum.map(fn {size, index, contents} ->
        {contents ++ [{size, 0}], index}
      end)

    combined = final_spaces ++ unfitted

    combined
    |> Enum.sort(&(elem(&1, 1) < elem(&2, 1)))
    |> Enum.map(fn line ->
      case line do
        {[], _} ->
          []

        {list, _} when is_list(list) ->
          Enum.flat_map(list, fn {size, id} ->
            List.duplicate(id, size)
          end)

        {size, index} ->
          List.duplicate(index, size)
      end
    end)
    # |> IO.inspect(charlist: :as_lists)
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.map(fn {x, index} -> x * index end)
    |> Enum.sum()
  end

  def part2(args) do
    {{files, spaces}, _max_index} =
      args
      |> String.trim()
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2, 2, [0])
      |> Enum.with_index()
      |> Enum.reduce({{_files = %{}, _spaces = []}, _block_index = 0}, fn {[
                                                                             file_size,
                                                                             space_size
                                                                           ], file_id},
                                                                          {{files, spaces},
                                                                           block_index} ->
        # {block, space} = {String.to_integer(block_str), String.to_integer(space_str)}
        new_files =
          Map.update(files, file_size, [{file_id, block_index}], fn list ->
            [{file_id, block_index} | list]
          end)

        new_block_index = block_index + file_size
        new_spaces = [{space_size, new_block_index} | spaces]
        {{new_files, new_spaces}, new_block_index + file_size}
      end)
      |> IO.inspect()

    # Loop through spaces finding files that fit
    # What follows is an absolute mess that I did not finish.
    # I also hate the style
    Enum.reduce(
      spaces |> Enum.reverse(),
      {_filled_spaces = [], files, _unplaced_blocks = []},
      fn {space_size, space_index}, {filled_spaces, files, unplaced_blocks} ->
        # find the key for group of files with the rightmost file that fits (files grouped by size)
        {key, _} =
          Enum.reduce(files, {nil, 0}, fn {file_size, files}, {key, old_index} ->
            IO.inspect({file_size, space_size, space_index, files}, label: "WHERE?")

            if file_size > space_size or files == [] do
              # No suitable piece in this group
              {key, old_index}
            else
              {_new_id, new_index} = hd(files)

              if new_index > old_index do
                {file_size, new_index}
              else
                {key, old_index}
              end
            end
          end)
          |> IO.inspect()

        if key == nil do
          {filled_spaces, files, unplaced_blocks}
        else
          # [{file_id, block_index} | rest] = Map.get(files, key)
          # new_files = Map.put(files, key, rest)
          # {filled_spaces, rest, unplaced_blocks}
        end
      end
    )
  end
end
