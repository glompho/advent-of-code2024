defmodule AdventOfCode.Day19 do
  def check_pattern(design, full_list) do
    check_pattern(design, full_list, full_list)
  end

  def check_pattern(design, [], full_list) do
    {:not_possible}
  end

  def check_pattern(first_pattern, [first_pattern | rest], full_list) do
    {:possible, [first_pattern | rest]}
  end

  def check_pattern(design, [first_pattern | rest], full_list) do
    {first_segment, rem_design} = String.split_at(design, String.length(first_pattern))

    if first_segment == first_pattern do
      case check_pattern(rem_design, full_list) do
        {:possible, pattern_list} -> {:possible, [design, rem_design | full_list]}
        {:not_possible} -> check_pattern(design, rest, full_list)
      end
    else
      check_pattern(design, rest, full_list)
    end
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
        {:possible, npatterns} -> {count + 1, npatterns}
        {:not_possible} -> {count, patterns |> Enum.sort_by(&byte_size/1, &>=/2)}
      end
    end)
    |> elem(0)
  end

  def part2(_args) do
  end
end
