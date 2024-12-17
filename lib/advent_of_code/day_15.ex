defmodule AdventOfCode.Day15 do
  def get_dimensions(input) do
    input
    |> String.split("\n", trim: true)
    |> then(fn list -> {String.length(hd(list)) - 1, length(list) - 1} end)
  end

  def string_grid_to_map(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({%{}, nil}, fn {line, y}, {grid, start_pos} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce({grid, start_pos}, fn {char, x}, {grid, start_pos} ->
        if char == "@" do
          {Map.put(grid, {x, y}, "."), {x, y}}
        else
          {Map.put(grid, {x, y}, char), start_pos}
        end
      end)
    end)
  end

  def draw_grid({{ax, ay}, map}, max_x, max_y) do
    for y <- Range.new(0, max_y) do
      Enum.map(Range.new(0, max_x), fn x ->
        cond do
          {ax, ay} == {x, y} -> "@"
          Map.has_key?(map, {x, y}) -> map[{x, y}]
          true -> " "
        end
      end)
      |> Enum.join()
    end

    # |> Enum.join("\n")
    # |> IO.inspect()

    # {{ax, ay}, map}
  end

  def print_grid(grid_list) do
    IO.puts("\n")

    Enum.map(grid_list, fn line ->
      IO.inspect(line)
      line
    end)
  end

  def parse_instructions(instructions) do
    instructions
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(fn char ->
      case char do
        "^" -> {0, -1}
        "v" -> {0, 1}
        ">" -> {1, 0}
        "<" -> {-1, 0}
        _ -> {0, 0}
      end
    end)
  end

  def try_move({dx, dy}, {x, y}, grid) do
    case grid[{x + dx, y + dy}] do
      "." -> {{x + dx, y + dy}, true}
      "#" -> {{x + dx, y + dy}, false}
      "O" -> try_move({dx, dy}, {x + dx, y + dy}, grid)
    end
  end

  def try_move2({dx, dy}, {x, y}, grid, swap_char, branch) do
    bodge_key = %{"." => ".", "[" => "]", "]" => "["}

    case grid[{x + dx, y + dy}] do
      "." ->
        [{{x + dx, y + dy}, swap_char, true}]

      "#" ->
        [{{x + dx, y + dy}, swap_char, false}]

      char when char == "[" or char == "]" ->
        branch_char =
          if swap_char == char do
            bodge_key[swap_char]
          else
            "."
          end

        cond do
          dy == 0 ->
            try_move2({dx, dy}, {x + dx, y + dy}, grid, char, false) ++
              [{{x + dx, y + dy}, swap_char, true}]

          branch == true ->
            try_move2({dx, dy}, {x + dx, y + dy}, grid, char, false) ++
              [{{x + dx, y + dy}, swap_char, true}]

          char == "[" ->
            try_move2({dx, dy}, {x + dx, y + dy}, grid, char, false) ++
              try_move2({dx, dy}, {x + dx + 1, y}, grid, branch_char, true) ++
              [{{x + dx, y + dy}, swap_char, true}]

          char == "]" ->
            try_move2({dx, dy}, {x + dx, y + dy}, grid, char, false) ++
              try_move2({dx, dy}, {x + dx - 1, y}, grid, branch_char, true) ++
              [{{x + dx, y + dy}, swap_char, true}]
        end
    end
  end

  def process_shove(grid, sequence) do
    sequence
    |> Enum.reduce(grid, fn {{x, y}, swap_char, _canshove}, grid ->
      Map.put(grid, {x, y}, swap_char)
    end)
  end

  def do_one_inst({dx, dy}, {{x, y}, grid}) do
    a = draw_grid({{x, y}, grid}, 19, 9)
    print_grid(a)
    # if String.contains?(Enum.join(a, ""), ".]") do
    # print_grid(a)
    # IO.gets("press enter to do next step")
    # end

    new_loc = {x + dx, y + dy}

    case grid[new_loc] do
      "." ->
        {new_loc, grid}

      "#" ->
        {{x, y}, grid}

      "O" ->
        {next_space, can_shove} = try_move({dx, dy}, {x, y}, grid)

        if can_shove do
          {new_loc,
           grid
           |> Map.put(next_space, "O")
           |> Map.put(new_loc, ".")}
        else
          {{x, y}, grid}
        end

      char when char == "[" or char == "]" ->
        sequence =
          try_move2({dx, dy}, {x, y}, grid, ".", false)
          |> IO.inspect()

        # Enum.find_value(sequence, false, fn {{_x, _y}, _char, can_shove} -> can_shove == false end)
        # |> IO.inspect()

        if Enum.find(sequence, false, fn {{_x, _y}, _char, can_shove} -> can_shove == false end) do
          {{x, y}, grid}
        else
          {new_loc, process_shove(grid, sequence)}
        end
    end
  end

  def follow_instructions({sx, sy}, start_grid, instructions) do
    instructions
    |> Enum.reduce({{sx, sy}, start_grid}, &do_one_inst/2)
  end

  def score_grid({_pos, map}) do
    map
    |> Enum.reduce(0, fn {{x, y}, char}, acc ->
      case char do
        "O" -> acc + (x + y * 100)
        "[" -> acc + (x + y * 100)
        _ -> acc
      end
    end)
  end

  def part1(input) do
    [grid, instructions] =
      input
      |> String.split("\n\n", trim: true)

    # {max_x, max_y} = get_dimensions(grid)

    {grid_map, {start_x, start_y}} =
      grid
      |> string_grid_to_map()

    instructions = parse_instructions(instructions)

    follow_instructions({start_x, start_y}, grid_map, instructions)
    # |> draw_grid(max_x, max_y)
    |> score_grid()
  end

  def part2(input, double_input \\ true) do
    input =
      if double_input do
        input
        |> String.replace(["#", "O", ".", "@"], fn char ->
          case char do
            "#" -> "##"
            "." -> ".."
            "O" -> "[]"
            "@" -> "@."
          end
        end)
      else
        input
      end

    [grid, instructions] =
      input
      |> String.split("\n\n", trim: true)

    {max_x, max_y} = get_dimensions(grid) |> IO.inspect()

    {grid_map, {start_x, start_y}} =
      grid
      |> string_grid_to_map()

    draw_grid({{start_x, start_y}, grid_map}, max_x, max_y)

    # |> Enum.take(1)
    instructions = parse_instructions(instructions)

    final_grid = follow_instructions({start_x, start_y}, grid_map, instructions)

    draw_grid(final_grid, max_x, max_y)
    score_grid(final_grid)
  end
end
