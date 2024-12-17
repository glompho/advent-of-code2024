defmodule AdventOfCode.Day16 do
  def draw_grid(map) do
    [max_x, max_y] =
      Map.keys(map)
      |> Enum.unzip()
      |> Tuple.to_list()
      |> Enum.map(&Enum.max/1)

    for y <- Range.new(0, max_y) do
      Enum.map(Range.new(0, max_x), fn x ->
        cond do
          Map.has_key?(map, {x, y}) -> map[{x, y}]
          true -> " "
        end
      end)
      |> Enum.join()
    end
    |> Enum.join("\n")
  end

  def parse(input) do
    input
    |> String.split(["\n", "\r"], trim: true)
    |> Enum.with_index()
    |> Enum.reduce({%{}, nil, nil}, fn {line, y}, {map, start_pos, end_pos} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce({map, start_pos, end_pos}, fn {char, x}, {map, start_pos, end_pos} ->
        new_map = Map.put(map, {x, y}, char)

        case char do
          "S" -> {new_map, {x, y}, end_pos}
          "E" -> {new_map, start_pos, {x, y}}
          _ -> {new_map, start_pos, end_pos}
        end
      end)
    end)
  end

  def find_routes({x, y}, {dx, dy}, score, grid, visited, route) do
    possible_moves = [
      {{x, y}, {dx, dy}, score + 1},
      {{x, y}, {-dy, dx}, score + 1001},
      {{x, y}, {dy, -dx}, score + 1001}
    ]

    {r, v} =
      Enum.reduce(possible_moves, {[], visited}, fn {{x, y}, {dx, dy}, score},
                                                    {routes, visited_acc} ->
        take_step({x + dx, y + dy}, {dx, dy}, score, grid, visited_acc, route)
        |> case do
          {:ok, new_routes, new_visited} ->
            {routes ++ new_routes, new_visited}

          {:error, _} ->
            {routes, visited_acc}
        end
      end)

    {:ok, r, v}
  end

  def take_step({x, y}, {dx, dy}, score, grid, visited, route) do
    # |> IO.inspect()
    key = {x, y, dx, dy}
    # IO.inspect(Map.get(grid, {x, y}))

    if Map.get(visited, key, 10_00000) < score do
      # Prune this path
      {:error, :already_visited}
    else
      new_visited = Map.put(visited, key, score)
      new_route = [{x, y} | route]

      case Map.get(grid, {x, y}) do
        "#" ->
          # Dead end
          {:error, :wall}

        "E" ->
          # Found a route
          {:ok, [{new_route, score}], new_visited}

        nil ->
          # Out of bounds
          {:error, :out_of_bounds}

        _ ->
          find_routes({x, y}, {dx, dy}, score, grid, new_visited, new_route)
      end
    end
  end

  def part1(input) do
    {grid, start_pos, _end_pos} = parse(input)

    # draw_grid(grid) |> IO.puts()

    {:ok, routes, visited} =
      find_routes(start_pos, {1, 0}, 0, grid, %{}, [start_pos])

    {route, result} =
      routes
      |> Enum.min_by(fn {_route, score} -> score end)

    IO.puts("\n")
    IO.puts(length(route))

    Enum.reduce(Map.keys(visited), grid, fn {x, y, _dx, _dy}, grid ->
      Map.put(grid, {x, y}, "X")
    end)
    |> draw_grid()

    # |> IO.puts()

    result
  end

  def part2(input) do
    {grid, start_pos, _end_pos} = parse(input)

    {:ok, routes, visited} =
      find_routes(start_pos, {1, 0}, 0, grid, %{}, [start_pos])

    {_route, min} =
      routes
      |> Enum.min_by(fn {_route, score} -> score end)

    routes
    |> Enum.filter(fn {_route, score} -> score == min end)
    |> Enum.flat_map(fn {route, _score} -> route end)
    |> Enum.uniq()
    |> Enum.count()
  end
end
