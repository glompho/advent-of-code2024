defmodule AdventOfCode.Day06 do
  def fetch(grid, x, y) do
    Enum.at(Enum.at(grid, y), x)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def start(grid) do
    y = Enum.find_index(grid, &Enum.find_index(&1, fn n -> n == "^" end))
    x = Enum.find_index(Enum.at(grid, y), fn n -> n == "^" end)

    # Assuming the start direction
    # direction_to_vector = %{"^" => [0, -1], ">" => [1, 0], "v" => [0, 1], "<" => [-1, 0]}
    # [dx, dy] = direction_to_vector[fetch(grid, x, y)]

    grid_walk(grid, x, y, 0, -1)
  end

  def grid_walk(grid, x, y, dx, dy, visited \\ MapSet.new()) do
    # IO.inspect({x, y, dx, dy})
    new_x = x + dx
    new_y = y + dy
    new_visited = MapSet.put(visited, {{x, y}, {dx, dy}})

    cond do
      MapSet.member?(visited, {{x, y}, {dx, dy}}) ->
        :loop

      new_y < 0 or new_y >= length(grid) ->
        new_visited

      new_x < 0 or new_x >= length(Enum.at(grid, new_y)) ->
        new_visited

      true ->
        case fetch(grid, new_x, new_y) do
          "." -> grid_walk(grid, new_x, new_y, dx, dy, new_visited)
          "^" -> grid_walk(grid, new_x, new_y, dx, dy, new_visited)
          "#" -> grid_walk(grid, x, y, dy * -1, dx, new_visited)
        end
    end
  end

  def part1(args) do
    args
    |> parse()
    |> start()
    |> MapSet.to_list()
    |> Enum.map(fn {{x, y}, {_dx, _dy}} -> {x, y} end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def swap_char(grid, x, y) do
    List.update_at(
      grid,
      y,
      &List.update_at(&1, x, fn char ->
        case char do
          "." -> "#"
          char -> char
        end
      end)
    )
  end

  def part2(args) do
    # slow but works
    grid = parse(args)

    start(grid)
    |> MapSet.to_list()
    |> Enum.map(fn {{x, y}, {_dx, _dy}} -> {x, y} end)
    |> Enum.uniq()
    |> Enum.map(fn {x, y} ->
      # IO.inspect([x, y], charlists: :as_lists)
      start(swap_char(grid, x, y))
    end)
    |> Enum.count(&(&1 == :loop))
  end
end
