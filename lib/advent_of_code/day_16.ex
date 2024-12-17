defmodule AdventOfCode.Day16 do
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

    possible_moves
    |> Enum.flat_map(fn {{x, y}, {dx, dy}, score} ->
      take_step({x + dx, y + dy}, {dx, dy}, score, grid, visited, route)
    end)
  end

  def take_step({x, y}, {dx, dy}, score, grid, visited, route) do
    # IO.inspect({{x, y}, grid[{x, y}], score, Map.get(visited, {x, y, dx, dy}, 10_000_000)})

    if Map.get(visited, {x, y, dx, dy}, 10_0000) < score do
      []
    else
      new_visted = Map.put(visited, {x, y, dx, dy}, score)
      new_route = [{x, y} | route]
      # new_grid = Map.put(grid, {x, y}, "X")

      case grid[{x, y}] do
        "#" -> []
        "E" -> [{route, score}]
        "." -> find_routes({x, y}, {dx, dy}, score, grid, new_visted, new_route)
        "S" -> find_routes({x, y}, {dx, dy}, score, grid, new_visted, new_route)
      end
    end
  end

  def part1(input) do
    {grid, start_pos, _end_pos} = parse(input)

    {route, result} =
      find_routes(start_pos, {1, 0}, 0, grid, %{start_pos => true}, [start_pos])
      |> Enum.min_by(fn {_route, score} -> score end)

    # IO.puts("\n")
    # IO.puts(length(route))

    route_map =
      Enum.reduce(route, grid, fn {x, y}, grid ->
        Map.put(grid, {x, y}, "X")
      end)
      |> draw_grid()

    # |> IO.puts()

    result
  end

  def part2(_args) do
  end

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
end
