defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  test "adv" do
    assert adv(2, 8, 0, 0) == {2, 0, 0}
    assert adv(4, 8, 0, 0) == {0, 0, 0}
  end

  test "bx1" do
    assert bxl(3, 0, 5, 0) == {0, 6, 0}
  end

  test "one_command" do
    assert one_command(2, 6, 0, 0, 9, 0) == {0, 1, 9}
    assert one_command(1, 7, 0, 29, 0, 0) == {0, 26, 0}
    assert one_command(4, 0, 0, 2024, 43690, 0) == {0, 44354, 43690}
  end

  test "part1_small_test" do
    input = "Register A: 10
Register B: 0
Register C: 0

Program: 5,0,5,1,5,4"
    result = part1(input)

    assert result == "0,1,2"
  end

  test "part1" do
    input = "Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0"
    result = part1(input)

    assert result == "4,6,3,5,6,3,5,2,1,0"
  end

  test "part2" do
    input = "Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0"
    result = part2(input)

    assert result == 117_440
  end
end
