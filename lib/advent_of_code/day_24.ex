defmodule AdventOfCode.Day24 do
  def compute_one(a, command, b) do
    case command do
      "AND" ->
        Bitwise.&&&(a, b)

      "OR" ->
        Bitwise.|||(a, b)

      "XOR" ->
        Bitwise.bxor(a, b)
    end
  end

  def process_commands(values, []) do
    values
  end

  def process_commands(values, [[a, command, b, target] = head | rem_commands]) do
    if values[a] == nil or values[b] == nil do
      process_commands(values, rem_commands ++ [head])
    else
      new_v = compute_one(values[a], command, values[b])
      # IO.inspect({head, values[a], values[b], new_v})
      new_values = Map.put(values, target, new_v)

      process_commands(new_values, rem_commands)
    end
  end

  def values_to_num(values) do
    values
    |> Enum.reduce([], fn {key, value}, acc ->
      case key do
        "z" <> n -> [2 ** String.to_integer(n) * value | acc]
        _other -> acc
      end
    end)
    |> Enum.sum()
  end

  def part1(args) do
    [vs, ws] =
      args
      |> String.split("\n\n", trim: true)

    values =
      vs
      |> String.split([": ", "\n"], trim: true)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [a, b] -> {a, String.to_integer(b)} end)
      |> Map.new()

    wires =
      ws
      |> String.split([" -> ", "\n", " "], trim: true)
      |> Enum.chunk_every(4)

    IO.inspect(Enum.count(wires))

    process_commands(values, wires)
    |> values_to_num()
  end

  def part2(_args) do
  end
end
