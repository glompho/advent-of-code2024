defmodule AdventOfCode.Day19 do
  def check_pattern(design, pattern_map) do
    if Map.has_key?(pattern_map, design) do
      IO.inspect({design, Map.get(pattern_map, design)})
      {:possible, pattern_map, Map.get(pattern_map, design)}
    else
      list =
        pattern_map
        |> Map.keys()
        |> Enum.sort_by(&byte_size/1, &>=/2)

      check_pattern(design, list, pattern_map)
    end
  end

  def check_pattern(_design, [], pattern_map) do
    {:not_possible, [], 0}
  end

  def check_pattern(first_pattern, [first_pattern | rest], pattern_map) do
    # found one way but need to keep going
    {_, _, other_ways} = check_pattern(first_pattern, rest, pattern_map)
    {:possible, pattern_map, pattern_map[first_pattern] + other_ways}
  end

  def check_pattern(design, [first_pattern | rest], pattern_map) do
    {first_segment, rem_design} = String.split_at(design, String.length(first_pattern))

    if first_segment == first_pattern do
      case check_pattern(rem_design, pattern_map) do
        {:possible, pattern_list, parts} ->
          {_, _, other_ways} = check_pattern(design, rest, pattern_map)
          # IO.inspect({rem_design, parts})

          new_pattern_map =
            pattern_list

          # |> Map.put(design, pattern_map[first_segment] * parts + other_ways)

          # |> Map.put(rem_design, parts)

          # IO.inspect({first_pattern, rem_design, Enum.count(new_pattern_map)})
          {:possible, new_pattern_map, pattern_map[first_segment] * parts + other_ways}

        {:not_possible, _, _} ->
          check_pattern(design, rest, pattern_map)
      end
    else
      check_pattern(design, rest, pattern_map)
    end
  end

  def make_ways(first_part, sub_ways) do
    Enum.map(sub_ways, fn way -> [first_part | way] end)
  end

  def new_check_patern("", [], _patterns, cache) do
    {1, cache}
  end

  def new_check_patern(_design, [], _patterns, cache) do
    {0, cache}
  end

  def new_check_patern(design, [first_pattern | rem_patterns], patterns, cache) do
    # IO.inspect({design, cache[design]})

    case cache[design] do
      nil ->
        {first_segment, rem_design} = String.split_at(design, String.length(first_pattern))

        if first_segment == first_pattern do
          {rem_ways, cache} = new_check_patern(rem_design, patterns, patterns, cache)
          {other_ways, cache} = new_check_patern(design, rem_patterns, patterns, cache)
          # IO.inspect({first_pattern, rem_ways, other_ways})
          ways = rem_ways + other_ways
          new_cache = Map.put(cache, design, ways)
          {ways, new_cache}
        else
          new_check_patern(design, rem_patterns, patterns, cache)
        end

      ways ->
        {ways, cache}
    end

    # |> IO.inspect()
  end

  def part2(args) do
    [pattern_string, designs] = String.split(args, "\n\n", trim: true)

    patterns =
      String.split(pattern_string, ", ", trim: true)

    # |> IO.inspect()

    designs
    |> String.split("\n", trim: true)
    # |> IO.inspect()
    # |> Enum.slice(3, 1)
    # |> IO.inspect()
    |> Enum.reduce({0, %{}}, fn design, {count, cache} ->
      IO.inspect(design)
      {ways, cache} = new_check_patern(design, patterns, patterns, cache)
      {count + ways, cache}
    end)
    |> elem(0)
  end

  def part1(args) do
    [pattern_string, designs] = String.split(args, "\n\n", trim: true)

    patterns =
      String.split(pattern_string, ", ", trim: true)
      |> Enum.sort_by(&byte_size/1, &>=/2)

    # |> IO.inspect()

    designs
    |> String.split("\n", trim: true)
    # |> IO.inspect()
    # |> Enum.slice(0, 2)
    |> Enum.reduce({0, patterns}, fn design, {count, patterns} ->
      case check_pattern(design, patterns) do
        {:possible, npatterns, _parts} -> {count + 1, npatterns}
        {:not_possible} -> {count, patterns |> Enum.sort_by(&byte_size/1, &>=/2)}
      end
    end)
    |> elem(0)
  end
end
