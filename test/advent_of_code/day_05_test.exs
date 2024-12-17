defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  test "test_check_rule" do
    assert check_rule([47, 53], [75, 47, 61, 53, 29]) == true
    assert check_rule([53, 47], [75, 47, 61, 53, 29]) == false
    assert check_rule([47, 100], [75, 47, 61, 53, 29]) == true
    assert check_rule([1, 75], [75, 47, 61, 53, 29]) == true
  end

  test "part1" do
    input = "
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"

    result = part1(input)

    assert result == 143
  end

  test "part2" do
    input = "
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"

    [rules, _] = parse(input)

    assert sort_function(53, 13, rules) == true
    assert sort_function(13, 53, rules) == false
    assert sort_function(53, 53, rules) == true

    result = part2(input)

    assert result == 123
  end
end
