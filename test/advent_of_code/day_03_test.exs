defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  test "part1" do
    input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    result = part1(input)

    assert result == 161
  end

  test "part2" do
    input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    result = part2(input)

    assert result == 48
  end

  test "part2_test 2" do
    input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    result = part1(input)

    assert result == 161
  end

  test "part2_don't_excludes" do
    input = "don't()mul(1,2)don't()do()"
    result = part2(input)

    assert result == 0
  end

  test "part2_test3" do
    input = "do()mul(1,2)don't()do()"
    result = part2(input)

    assert result == 2
  end

  test "part2_test_line_breaks" do
    input = "do()mul(1,2)\n
    don't()do()"
    result = part2(input)

    assert result == 2
  end
end
