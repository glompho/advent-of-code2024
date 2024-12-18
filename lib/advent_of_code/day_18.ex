defmodule AdventOfCode.Day18 do
  def print_grid(grid, ex, ey) do
    IO.puts("\n")

    for y <- 0..ey do
      for x <- 0..ex do
        case grid[{x, y}] do
          "#" -> "#"
          _ -> "."
        end
      end
      |> IO.puts()
    end

    grid
  end

  def path_find(grid, {x, y}, {ex, ey}, route, visited) do
    directions = [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
    # IO.inspect({{x, y}, {ex, ey}})
    # IO.inspect({x, y, x < 0, x >= ex, y < 0, y >= ey, grid[{x, y}] == "#", visited[{x, y}]})

    cond do
      x < 0 or x > ex or y < 0 or y > ey or grid[{x, y}] == "#" or visited[{x, y}] == true ->
        []

      x == ex and y == ey ->
        route

      true ->
        new_visited = Map.put(visited, {x, y}, true)

        paths =
          Enum.map(directions, fn {dx, dy} ->
            path_find(grid, {x + dx, y + dy}, {ex, ey}, [{x, y} | route], new_visited)
          end)
          |> Enum.reject(&(&1 == []))

        if paths == [] do
          []
        else
          Enum.min_by(paths, &Enum.count/1)
        end
    end
  end

  def part1(input, ex \\ 70, ey \\ 70, bytes \\ 1024) do
    input
    |> String.split(["\n", ","])
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.take(bytes)
    |> Enum.map(fn [x, y] -> {{x, y}, "#"} end)
    |> Map.new()
    |> print_grid(ex, ey)
    |> path_find({0, 0}, {ex, ey}, [], %{})
    # |> List.flatten()
    |> Enum.count()
  end

  def part2(_args) do
  end
end
