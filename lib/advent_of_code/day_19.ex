defmodule AdventOfCode.Day19 do
  def check_patern("", [], _patterns, cache) do
    {1, cache}
  end

  def check_patern(_design, [], _patterns, cache) do
    {0, cache}
  end

  def check_patern(design, [first_pattern | rem_patterns], patterns, cache) do
    case cache[design] do
      nil ->
        {first_segment, rem_design} = String.split_at(design, String.length(first_pattern))

        if first_segment == first_pattern do
          {rem_ways, cache} = check_patern(rem_design, patterns, patterns, cache)
          {other_ways, cache} = check_patern(design, rem_patterns, patterns, cache)
          ways = rem_ways + other_ways
          new_cache = Map.put(cache, design, ways)
          {ways, new_cache}
        else
          check_patern(design, rem_patterns, patterns, cache)
        end

      ways ->
        {ways, cache}
    end
  end

  def parse(args) do
    [pattern_string | designs] = String.split(args, "\n", trim: true)
    patterns = String.split(pattern_string, ", ", trim: true)
    {patterns, designs}
  end

  def part2(args) do
    {patterns, designs} = parse(args)

    designs
    |> Enum.reduce({0, %{}}, fn design, {count, cache} ->
      {ways, cache} = check_patern(design, patterns, patterns, cache)
      {count + ways, cache}
    end)
    |> elem(0)
  end

  def part1(args) do
    {patterns, designs} = parse(args)

    designs
    |> Enum.reduce({0, %{}}, fn design, {count, cache} ->
      case check_patern(design, patterns, patterns, cache) do
        {0, cache} -> {count, cache}
        {_ways, cache} -> {count + 1, cache}
      end
    end)
    |> elem(0)
  end
end
