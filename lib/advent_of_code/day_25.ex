defmodule AdventOfCode.Day25 do
  def parse_one(input) do
    lines = String.split(input, "\n")

    totals =
      Enum.reduce(lines, %{}, fn line, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, index}, acc ->
          case char do
            "#" -> Map.update(acc, index, 0, &(&1 + 1))
            _other -> acc
          end
        end)
      end)

    case hd(lines) do
      "#####" -> {:locks, totals}
      "....." -> {:keys, totals}
    end
  end

  def part1(args) do
    parsed =
      args
      |> String.split("\n\n")
      |> Enum.map(&parse_one/1)
      |> Enum.group_by(fn {type, _totals} -> type end, fn {_type, totals} -> totals end)

    Enum.reduce(parsed[:locks], 0, fn lock, acc ->
      Enum.reduce(parsed[:keys], acc, fn key, acc ->
        max_clash =
          Map.merge(key, lock, fn _k, v1, v2 ->
            v1 + v2
          end)
          |> Map.values()
          |> Enum.max()

        if max_clash > 5 do
          acc
        else
          acc + 1
        end
      end)
    end)
  end

  def part2(_args) do
  end
end
