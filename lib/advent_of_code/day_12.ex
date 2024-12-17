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

  def is_corner({_x, _y}, grid_map) do
    [{0, 1}, {1, 1}, {1, 0}]
    |> Enum.map(&Map.get(grid_map, &1))
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
        {area, edge} = crawl({x, y}, char, grid_map, [], [])

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

  def find_edge(edges, {x, y}, {dx, dy}) do
    if Enum.member?(edges, {x, y}) do
      remaining_edges = edges -- [{x, y}]
      lh = find_edge(remaining_edges, {x - dx, y - dy}, {dx, dy})
      rh = find_edge(remaining_edges, {x + dx, y + dy}, {dx, dy})
      [{x, y}] ++ lh ++ rh
    else
      []
    end
  end

  def find_edges([{x, y} | _rest] = edges, {dx, dy}, acc) do
    edge = find_edge(edges, {x, y}, {dx, dy})
    IO.inspect(edges, label: "before")
    IO.inspect(edge, lebel: "edge")
    IO.inspect(edges -- edge, label: "after")
    # IO.inspect(edge, label: "{x,y} goes to edge")
    find_edges(edges -- edge, {dx, dy}, acc ++ [edge])
  end

  def find_edges([], {_dx, _dy}, acc) do
    acc
  end

  def count_sides(edges) do
    # IO.inspect(edges)
    # IO.inspect(edges |> Enum.uniq())

    fp =
      find_edges(edges, {1, 0}, [])

    # |> IO.inspect(label: "hedges")

    vedges =
      fp
      |> Enum.filter(&(length(&1) == 1))
      |> Enum.map(fn [{x, y}] -> {x, y} end)
      |> find_edges({0, 1}, [])

    # |> find_edges({0, 1}, [])
    # |> Enum.uniq()
    # |> IO.inspect(label: "vedges")

    hedges =
      fp
      |> Enum.filter(&(length(&1) != 1))

    (vedges ++ hedges)
    # |> IO.inspect(label: "both")
    |> Enum.count()
  end

  def part2(input) do
    regions = find_regions(input)

    regions
    |> elem(0)
    |> Enum.map(fn {name, {area, edges}} ->
      sides = count_sides(edges)
      IO.inspect({name, sides})

      Enum.count(area) * sides
    end)
    |> Enum.sum()
  end
end
