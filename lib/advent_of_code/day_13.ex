defmodule AdventOfCode.Day13 do
  def solve(line, offset) do
    [x1, y1, x2, y2, opx, opy] = line
    px = opx + offset
    py = opy + offset
    b = div(px * y1 - x1 * py, y1 * x2 - y2 * x1)
    a = div(px - b * x2, x1)

    if a * x1 + b * x2 == px and a * y1 + b * y2 == py do
      {a, b}
    else
      :no_solutions
    end
  end

  def part1(input, offset \\ 0) do
    input
    |> String.split(["Button A: X+", "Button B: X+", ", Y+", "Prize: X=", ", Y=", "\n", "\r"],
      trim: true
    )
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(6)
    |> Enum.map(&solve(&1, offset))
    |> Enum.filter(&(&1 != :no_solutions))
    |> Enum.map(fn {a, b} -> 3 * a + b end)
    |> Enum.sum()
  end

  def part2(input) do
    part1(input, 10_000_000_000_000)
  end
end
