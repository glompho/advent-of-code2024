defmodule AdventOfCode.Day12 do
  def string_to_list_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Enum.with_index(String.split(&1, "", trim: true)))
    |> Enum.with_index()
  end

  def list_grid_to_map(list_grid) do
    list_grid
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      Enum.reduce(line, acc, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
  end

  def crawl({x, y}, {dx, dy}, char, grid_map, area, edges) do
    cond do
      grid_map[{x, y}] != char ->
        case {dx, dy} do
          {0, 1} -> {area, [{x, y, :t_edge} | edges]}
          {0, -1} -> {area, [{x, y, :b_edge} | edges]}
          {1, 0} -> {area, [{x, y, :l_edge} | edges]}
          {-1, 0} -> {area, [{x, y, :r_edge} | edges]}
        end

      Enum.member?(area, {x, y}) == true or Enum.member?(edges, {x, y}) == true ->
        {area, edges}

      true ->
        [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
        |> Enum.reduce({[{x, y} | area], edges}, fn {dx, dy}, {narea, nedges} ->
          crawl({x + dx, y + dy}, {dx, dy}, char, grid_map, narea, nedges)
        end)
    end
  end

  def find_regions(input) do
    grid_map =
      input
      |> string_to_list_grid()
      |> list_grid_to_map()

    grid_map
    |> Enum.reduce({%{}, MapSet.new()}, fn {{x, y}, char}, {seen_map, seen_list} ->
      if Enum.member?(seen_list, {x, y}) do
        {seen_map, seen_list}
      else
        {area, edge} = crawl({x, y}, {0, 0}, char, grid_map, [], [])

        {Map.put(seen_map, {{x, y}, char}, {area, edge}),
         MapSet.union(MapSet.new(area), seen_list)}
      end
    end)
  end

  def part1(input) do
    regions = find_regions(input)

    regions
    |> elem(0)
    |> Enum.map(fn {_name, {area, edges}} ->
      Enum.count(area) * Enum.count(edges)
    end)
    |> Enum.sum()
  end

  def count_all_sides(edges) do
    edges
    |> Enum.group_by(fn {_x, _y, type} -> type end)
    |> Enum.map(fn {type, sides} ->
      case type do
        :t_edge -> {type, sides}
        :b_edge -> {type, sides}
        :l_edge -> {type, Enum.map(sides, fn {x, y, type} -> {y, x, type} end)}
        :r_edge -> {type, Enum.map(sides, fn {x, y, type} -> {y, x, type} end)}
      end
    end)
    |> Enum.map(fn {_type, sides} ->
      # converted all cases to horizontal above so that this logic is the same for all.
      sides
      |> Enum.group_by(fn {_x, y, _type} -> y end, fn {x, _y, _type} -> x end)
      |> Map.values()
      |> Enum.map(fn x_values ->
        x_values
        |> Enum.sort()
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [a, b] -> abs(a - b) end)
        |> Enum.filter(fn x -> x != 1 end)
        |> Enum.count()
        |> then(&(&1 + 1))
      end)
      |> Enum.sum()
    end)

    # |> IO.inspect(charlists: :as_list)
    |> Enum.sum()
  end

  def part2(input) do
    regions = find_regions(input)

    regions
    |> elem(0)
    |> Enum.map(fn {_name, {area, edges}} ->
      # IO.inspect(name)
      sides = count_all_sides(edges)
      # IO.inspect({name, sides, Enum.count(area) * sides})
      Enum.count(area) * sides
    end)
    |> Enum.sum()
  end
end
