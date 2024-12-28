#
defmodule AdventOfCode.Day23 do
  def find_cycles(start_node, size, network) do
    find_cycles(start_node, start_node, size, [], network)
  end

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

  def parse(args) do
    args
    |> String.split(["\n", "-", " "], trim: true)
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
  end

  def part1(args) do
    connections = parse(args)

    connections
    |> Map.keys()
    |> Enum.filter(fn name ->
      case name do
        "t" <> _ -> true
        _other -> false
      end
    end)
    |> Enum.flat_map(&find_cycles(&1, 3, connections))
    |> Enum.uniq()
    |> Enum.count()
  end

  def find_largest_clique(node, network) do
    # finds the largest clique from a particular node in the network
    Enum.reduce(network[node], MapSet.new([node]), fn next_node, acc ->
      case MapSet.intersection(network[next_node], acc) do
        # if the intersection is equal to the clique so far
        # then it is connected to all current members
        ^acc -> MapSet.put(acc, next_node)
        _ -> acc
      end
    end)
  end

  def part2(args) do
    connections = parse(args)

    connections
    |> Map.keys()
    |> Enum.reduce(_cliques = [], fn node, cliques ->
      largest_clique = find_largest_clique(node, connections)
      [largest_clique | cliques]
    end)
    |> Enum.max()
    |> MapSet.to_list()
    |> Enum.sort()
    |> Enum.join(",")
  end
end
