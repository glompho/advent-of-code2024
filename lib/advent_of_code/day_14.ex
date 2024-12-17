defmodule AdventOfCode.Day14 do
  def mod(x, y) when x >= 0, do: rem(x, y)
  def mod(x, y) when x < 0, do: rem(rem(x, y) + y, y)
  def mod(0, _y), do: 0

  def walk_n(line, n, max_x, max_y) do
    [x, y, dx, dy] = line
    new_x = mod(x + dx * n, max_x)
    new_y = mod(y + dy * n, max_y)
    [new_x, new_y]
  end

  def find_state(input, max_x \\ 101, max_y \\ 103, n \\ 100) do
    input
    |> String.split(["p=", " v=", ",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4)
    |> Enum.map(&walk_n(&1, n, max_x, max_y))
    |> Enum.sort()
  end

  def quater(guards, max_x, max_y) do
    Enum.group_by(guards, fn [x, y] ->
      if x == div(max_x, 2) or y == div(max_y, 2) do
        :middle
      else
        {x > div(max_x, 2), y > div(max_y, 2)}
      end
    end)
    |> Map.delete(:middle)
  end

  def part1(input, max_x \\ 101, max_y \\ 103, n \\ 100) do
    state = find_state(input, max_x, max_y, n)

    state
    |> quater(max_x, max_y)
    |> Map.values()
    |> Enum.map(&Enum.count/1)
    |> Enum.product()
  end

  def draw_grid(list, max_x, max_y) do
    for y <- Range.new(0, max_y) do
      Enum.map(Range.new(0, max_x), fn x ->
        if Enum.member?(list, [x, y]) do
          "#"
        else
          " "
        end
      end)
      |> Enum.join()
      |> IO.puts()
    end
  end

  def list_grid_to_map(list_grid) do
    list_grid
    |> Enum.reduce(%{}, fn [x, y], acc ->
      Map.put(acc, {x, y}, "#")
    end)
  end

  def crawl({x, y}, char, grid_map, area, edges) do
    cond do
      grid_map[{x, y}] != char ->
        {area, [{x, y} | edges]}

      Enum.member?(area, {x, y}) == true or Enum.member?(edges, {x, y}) == true ->
        {area, edges}

      true ->
        [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
        |> Enum.reduce({[{x, y} | area], edges}, fn {dx, dy}, {narea, nedges} ->
          crawl({x + dx, y + dy}, char, grid_map, narea, nedges)
        end)
    end
  end

  def find_regions(list) do
    grid_map = list_grid_to_map(list)

    grid_map
    |> Enum.reduce({%{}, MapSet.new()}, fn {{x, y}, char}, {seen_map, seen_list} ->
      if Enum.member?(seen_list, {x, y}) do
        {seen_map, seen_list}
      else
        {area, edge} = crawl({x, y}, char, grid_map, [], [])

        {Map.put(seen_map, {{x, y}, char}, {area, edge}),
         MapSet.union(MapSet.new(area), seen_list)}
      end
    end)
  end

  def part2(input, max_x \\ 101, max_y \\ 103) do
    n =
      Stream.map(
        1..10000,
        &(find_state(input, max_x, max_y, &1)
          |> find_regions()
          |> elem(0)
          |> Enum.uniq()
          |> Enum.count())
      )
      |> Enum.take_while(&(&1 >= 300))
      |> Enum.count()

    # Changed number of regions by hand until 300 worked.

    draw_grid(find_state(input, 101, 103, n + 1), max_x, max_y)
    n + 1
  end
end
