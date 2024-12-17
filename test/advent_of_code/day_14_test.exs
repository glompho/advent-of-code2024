defmodule AdventOfCode.Day14Test do
  use ExUnit.Case

  import AdventOfCode.Day14

  def grid_string_to_map(grid_string) do
    grid_string
    |> String.split("\n", trim: true)
    |> Enum.map(&Enum.with_index(String.split(&1, "", trim: true)))
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      Enum.reduce(line, acc, fn {char, x}, acc ->
        Map.put(acc, [x, y], char)
      end)
    end)
  end

  test "mod" do
    assert mod(7, 7) == 0
    assert mod(-1, 7) == 6
    assert mod(0, 7) == 0
    assert mod(-294, 7) == 0
  end

  test "part1_one_guard_warps_right" do
    input = [2, 4, 2, -3]
    result = Enum.map(0..5, &walk_n(input, &1, 11, 7))
    assert result == [[2, 4], [4, 1], [6, 5], [8, 2], [10, 6], [1, 3]]
  end

  test "part1_problem_guard" do
    input = [7, 6, -1, -3]
    result = walk_n(input, 100, 11, 7)
    assert result == [6, 0]
  end

  test "part1_problem_guard_final_step" do
    input = [7, 3, -1, -3]
    result1 = walk_n(input, 1, 11, 7)

    assert result1 == [6, 0]
  end

  test "part1_after_100_example" do
    input = "p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3"

    end_state =
      "......2..1.
...........
1..........
.11........
.....1.....
...12......
.1....1...."
      |> grid_string_to_map()
      |> Map.to_list()
      |> Enum.filter(fn {_key, value} -> value != "." end)
      |> Enum.map(fn {cords, _char} -> cords end)
      |> Enum.sort()

    result = find_state(input, 11, 7, 100) |> Enum.uniq()

    assert result == end_state
  end

  test "part1" do
    input = "p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3"
    result = part1(input, 11, 7)

    assert result == 12
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)
    # You just have to look with the real input
    assert result
  end
end
