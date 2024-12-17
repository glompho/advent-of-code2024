defmodule AdventOfCode.Day07 do
  def parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split([": ", " "], trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part_one_totals([], acc) do
    [acc]
  end

  def part_one_totals([first | rest], acc) do
    part_one_totals(rest, acc * first) ++ part_one_totals(rest, acc + first)
  end

  def part_two_totals([], acc) do
    [acc]
  end

  def part_two_totals([first | rest], acc) do
    concat = String.to_integer(Integer.to_string(acc) <> Integer.to_string(first))

    part_two_totals(rest, concat) ++
      part_two_totals(rest, acc * first) ++
      part_two_totals(rest, acc + first)
  end

  def solve(args, func) do
    args
    |> parse()
    |> Enum.map(fn [target, first | list] ->
      Enum.find(func.(list, first), 0, &(&1 == target))
    end)
    |> Enum.sum()
  end

  def part1(args) do
    solve(args, &part_one_totals/2)
  end

  def part2(args) do
    solve(args, &part_two_totals/2)
  end
end
