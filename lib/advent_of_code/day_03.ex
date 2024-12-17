defmodule AdventOfCode.Day03 do
  def part1(args) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, args)
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end

  def part2(args) do
    Regex.scan(~r/do\(\)(.*?)don't\(\)/s, "do()" <> args <> "don't()")
    |> Enum.map(fn [_, good_bit] -> part1(good_bit) end)
    |> Enum.sum()
  end
end
