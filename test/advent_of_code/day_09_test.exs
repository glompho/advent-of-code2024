defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  test "part1" do
    input = "2333133121414131402"
    result = part1(input)

    assert result == 1928
  end

  @tag :skip
  test "part2" do
    input = "2333133121414131402"
    result = part2(input)

    assert result == 2858
  end
end
