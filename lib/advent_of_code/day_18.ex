defmodule AdventOfCode.Day18 do
  def print_grid(grid, ex, ey) do
    IO.puts("\n")

    for y <- 0..ey do
      for x <- 0..ex do
        case grid[{x, y}] do
          nil -> "."
          char -> char
        end
      end
      |> IO.puts()
    end

    grid
  end

  def not_legal_cell?(grid, {x, y}, {ex, ey}) do
    x < 0 or x > ex or y < 0 or y > ey or grid[{x, y}] == "#"
  end

  def path_find(grid, {x, y}, {ex, ey}, score, visited) do
    directions = [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
    # IO.inspect({{x, y}, {ex, ey}})
    # IO.inspect({x, y, x < 0, x >= ex, y < 0, y >= ey, grid[{x, y}] == "#", visited[{x, y}]})

    cond do
      not_legal_cell?(grid, {x, y}, {ex, ey}) or visited[{x, y}] == true ->
        {:error, "not a legitimate cell"}

      x == ex and y == ey ->
        {score, visited}

      true ->
        new_visited = Map.put(visited, {x, y}, true)
        new_score = score + 1

        new_grid =
          Enum.reduce(directions, grid, fn {dx, dy}, grid ->
            {new_x, new_y} = {x + dx, y + dy}

            cond do
              not_legal_cell?(grid, {new_x, new_y}, {ex, ey}) ->
                # IO.inspect("NOT LEGIT")
                grid

              Map.get(grid, {new_x, new_y}, :infinity) > new_score ->
                # IO.inspect("UPDATE")
                Map.put(grid, {new_x, new_y}, new_score)

              true ->
                # IO.inspect("FALLBACK")
                grid
            end
          end)

        # IO.inspect(new_visited, label: "visited")

        {{nx, ny}, value} =
          new_grid
          |> Enum.reject(fn {key, _value} ->
            Map.has_key?(new_visited, key)
          end)
          |> Enum.min_by(fn {_key, value} ->
            case value do
              "#" -> :infinity
              _ -> value
            end
          end)

        # |> IO.inspect()

        path_find(new_grid, {nx, ny}, {ex, ey}, value, new_visited)
    end
  end

  def part1(input, ex \\ 70, ey \\ 70, bytes \\ 1024) do
    map =
      input
      |> String.split(["\n", ","], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.take(bytes)
      |> Enum.map(fn [x, y] -> {{x, y}, "#"} end)
      |> Map.new()
      |> print_grid(ex, ey)

    {score, visited} = path_find(map, {0, 0}, {ex, ey}, 0, %{})

    Enum.reduce(visited, map, fn {{x, y}, value}, map ->
      Map.put(map, {x, y}, "X")
    end)
    |> print_grid(ex, ey)

    score
  end

  def part2(input) do
    part1(input, 6, 6, 13)
  end
end
