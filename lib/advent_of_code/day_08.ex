defmodule AdventOfCode.Day08 do
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
        Map.update(acc, char, [{x, y}], fn entry ->
          [{x, y} | entry]
        end)
      end)
    end)
  end

  def pairs([_]), do: []

  def pairs([head | tail]) do
    Enum.map(tail, fn item -> {head, item} end) ++ pairs(tail)
  end

  def count_antinodes(list, max_x, max_y, part) do
    list
    |> pairs()
    |> Enum.flat_map(fn {{x1, y1}, {x2, y2}} ->
      dx = x1 - x2
      dy = y1 - y2

      case part do
        :part1 ->
          [{x2 - dx, y2 - dy}, {x1 + dx, x1 + dy}]

        :part2 ->
          d1 =
            Stream.iterate({x2, y2}, fn {x, y} -> {x - dx, y - dy} end)
            |> Enum.take_while(fn {x, y} -> x >= 0 and x < max_x and y >= 0 and y < max_y end)

          d2 =
            Stream.iterate({x1, y1}, fn {x, y} -> {x + dx, y + dy} end)
            |> Enum.take_while(fn {x, y} -> x >= 0 and x < max_x and y >= 0 and y < max_y end)

          d1 ++ d2
      end
    end)
    |> Enum.filter(fn {x, y} ->
      # We could refacter this out but it is nice to see how I did part 1
      cond do
        x < 0 or x >= max_x -> false
        y < 0 or y >= max_y -> false
        true -> true
      end
    end)
  end

  def solve(args, part) do
    list_grid = string_to_list_grid(args)

    max_x = length(elem(hd(list_grid), 0))
    max_y = length(list_grid)

    grid = list_grid_to_map(list_grid)

    grid
    |> Map.keys()
    |> Enum.flat_map(fn char ->
      case char do
        "." -> []
        _ -> count_antinodes(grid[char], max_x, max_y, part)
      end
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part1(args) do
    solve(args, :part1)
  end

  def part2(args) do
    solve(args, :part2)
  end
end
