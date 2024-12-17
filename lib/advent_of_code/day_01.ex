defmodule AdventOfCode.Day01 do
  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "   "))
    |> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
    |> Enum.unzip()
    |> Tuple.to_list()
  end

  def part1(args) do
    args
    |> parse()
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip_with(fn [a, b] -> abs(b - a) end)
    |> Enum.sum()
  end

  def part2(args) do
    [list1, list2] = parse(args)

    list1
    |> Enum.map(fn x -> x * Map.get(Enum.frequencies(list2), x, 0) end)
    |> Enum.sum()
  end
end
