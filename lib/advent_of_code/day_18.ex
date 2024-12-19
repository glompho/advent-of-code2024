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
        {:error, "no way through"}

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

  def parse_input(input) do
    input
    |> String.split(["\n", ","], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
  end

  def parse_map(input, bytes) do
    input
    |> Enum.take(bytes)
    # |> IO.inspect()
    |> Enum.map(fn [x, y] -> {{x, y}, "#"} end)
    |> Map.new()
  end

  def part1(input, ex \\ 70, ey \\ 70, bytes \\ 1024) do
    map =
      input
      |> parse_input()
      |> parse_map(bytes)
      |> print_grid(ex, ey)

    {score, visited} = path_find(map, {0, 0}, {ex, ey}, 0, %{})

    Enum.reduce(visited, map, fn {{x, y}, value}, map ->
      Map.put(map, {x, y}, "X")
    end)
    |> print_grid(ex, ey)

    score
  end

  def part2_one_step(x, list, ex, ey) do
    map = parse_map(list, x)

    case path_find(map, {0, 0}, {ex, ey}, 0, %{}) do
      {:error, _} -> {:blocked, Enum.join(Enum.at(list, x - 1), ",")}
      {score, _visited} -> {:way_through, score}
    end
  end

  def part2_search(x, last_x, list, ex, ey) do
    interval = abs(last_x - x)
    # IO.inspect({x, last_x, interval, div(interval, 2)})

    case part2_one_step(x, list, ex, ey) do
      {:blocked, result} ->
        # IO.inspect({x, "blocked", result})

        if abs(last_x - x) == 1 do
          result
        else
          new_x = x - div(interval, 2)
          part2_search(new_x, x, list, ex, ey)
        end

      {:way_through, _score} ->
        # IO.inspect({x, "way through"})

        new_x = x + div(interval, 2) + 1

        if abs(last_x - x) == 1 do
          part2_search(last_x, x, list, ex, ey)
        else
          part2_search(new_x, x, list, ex, ey)
        end
    end
  end

  def part2(input, ex \\ 70, ey \\ 70) do
    list = parse_input(input)

    start_index = div(Enum.count(list), 2) |> IO.inspect()

    part2_search(start_index, 0, list, ex, ey)
  end
end
