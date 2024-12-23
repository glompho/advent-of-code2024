#
defmodule AdventOfCode.Day23 do
  def find_cycles(start_node, end_node, size, route, network) do
    cond do
      size > 0 ->
        Enum.reduce(network[start_node], [], fn next_node, acc ->
          find_cycles(next_node, end_node, size - 1, [start_node | route], network) ++ acc
        end)

      size == 0 and start_node == end_node ->
        [route |> Enum.reverse()]

      size == 0 ->
        []

      true ->
        nil
    end
    |> Enum.map(&MapSet.new/1)
    |> Enum.uniq()
  end

  def part1(args) do
    connections =
      args
      |> String.split(["\n", "-"], trim: true)
      |> Enum.chunk_every(2)
      |> Enum.reduce(%{}, fn [a, b], acc ->
        acc
        |> Map.update(a, MapSet.new([b]), fn current ->
          MapSet.put(current, b)
        end)
        |> Map.update(b, MapSet.new([a]), fn current ->
          MapSet.put(current, a)
        end)
      end)

    connections
    |> Map.keys()
    |> Enum.filter(fn name ->
      case name do
        "t" <> _ -> true
        _other -> false
      end
    end)
    |> Enum.flat_map(&find_cycles(&1, &1, 3, [], connections))
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2(_args) do
  end
end
