defmodule AdventOfCode.Day10 do
  def string_to_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Enum.with_index(String.split(&1, "", trim: true)))
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      Enum.reduce(line, acc, fn {char, x}, acc ->
        case Integer.parse(char) do
          {i, _} when is_number(i) -> Map.put(acc, {x, y}, i)
          :error -> Map.put(acc, {x, y}, char)
        end
      end)
    end)
  end

  def score_pos({x, y}, next_value, grid) do
    cond do
      grid[{x, y}] != next_value ->
        []

      next_value == 9 ->
        [{x, y}]

      true ->
        [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
        |> Enum.flat_map(fn {dx, dy} ->
          score_pos({x + dx, y + dy}, next_value + 1, grid)
        end)
    end
  end

  def solve(grid, func) do
    grid
    |> Map.keys()
    |> Enum.map(func)
    |> List.flatten()
    |> Enum.count()
  end

  def part1(args) do
    grid = string_to_grid(args)
    solve(grid, &(score_pos(&1, 0, grid) |> Enum.uniq()))
  end

  def part2(args) do
    grid = string_to_grid(args)
    solve(grid, &score_pos(&1, 0, grid))
  end
end
