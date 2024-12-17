defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  test "part1" do
    input = "OOOOO
OXOXO
OOOOO
OXOXO
OOOOO"
    result = part1(input)

    assert result == 772
  end

  test "part1_1" do
    input = "RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE"
    result = part1(input)

    assert result == 1930
  end

  @tag :skip
  test "part2" do
    input = "AAAA
BBCD
BBCC
EEEC"
    result = part2(input)

    assert result == 80
  end

  @tag :skip
  test "part2_2" do
    input = "EEEEE
EXXXX
EEEEE
EXXXX
EEEEE"
    result = part2(input)

    assert result == 236
  end
end
