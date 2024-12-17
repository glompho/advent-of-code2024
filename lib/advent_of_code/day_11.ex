defmodule AdventOfCode.Day11 do
  def iterate_stone(0), do: [1]

  def iterate_stone(x) do
    num_len = floor(:math.log10(x)) + 1

    if rem(num_len, 2) == 0 do
      magic_number = 10 ** div(num_len, 2)
      [div(x, magic_number), rem(x, magic_number)]
    else
      [x * 2024]
    end
  end

  def iterate_stones(map) do
    map
    |> Enum.reduce(map, fn {num, amount}, acc ->
      iterate_stone(num)
      |> Enum.reduce(acc, fn x, acc ->
        Map.update(acc, x, amount, &(&1 + amount))
      end)
      |> Map.update(num, 0, &(&1 - amount))
    end)
  end

  def solve(input, n) do
    parsed =
      input
      |> String.split([" ", "\n"], trim: true)
      |> Enum.map(&{String.to_integer(&1), 1})
      |> Map.new()

    Enum.reduce(1..n, parsed, fn _i, acc ->
      iterate_stones(acc)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def part1(input) do
    solve(input, 25)
  end

  def part2(input) do
    solve(input, 75)
  end
end
