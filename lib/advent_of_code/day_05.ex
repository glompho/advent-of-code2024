defmodule AdventOfCode.Day05 do
  def parse(args) do
    [unparsed_rules, u_lists] =
      args
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    rules =
      unparsed_rules
      |> Enum.map(fn line ->
        line
        |> String.split("|", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    lists =
      u_lists
      |> Enum.map(fn line ->
        line
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    [rules, lists]
  end

  def check_rule([a, b], list) do
    # slow to go through twice. Could write a custom traversal.
    a_index = Enum.find_index(list, &(&1 == a))
    b_index = Enum.find_index(list, &(&1 == b))

    cond do
      a_index == nil -> true
      b_index == nil -> true
      a_index < b_index -> true
      true -> false
    end
  end

  def part1(args) do
    [rules, lists] = parse(args)

    lists
    |> Enum.filter(fn line ->
      Enum.all?(
        Enum.map(rules, fn rule ->
          check_rule(rule, line)
        end)
      )
    end)
    |> Enum.map(fn line -> Enum.at(line, div(length(line), 2)) end)
    |> Enum.sum()
  end

  def sort_function(a, b, rules) do
    Enum.all?(rules, &check_rule(&1, [a, b]))
  end

  def part2(args) do
    [rules, lists] = parse(args)

    lists
    |> Enum.map(&Enum.sort(&1, fn a, b -> sort_function(a, b, rules) end))
    |> Enum.map(fn line -> Enum.at(line, div(length(line), 2)) end)
    |> Enum.sum()
    |> then(fn x -> x - part1(args) end)
  end
end
