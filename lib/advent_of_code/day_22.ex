defmodule AdventOfCode.Day22 do
  def mix(n, secret) do
    Bitwise.bxor(n, secret)
  end

  def prune(n) do
    rem(n, 16_777_216)
  end

  def mult(secret, n) do
    (secret * n)
    |> mix(secret)
    |> prune()
  end

  def sdiv(secret, n) do
    secret
    |> div(n)
    |> mix(secret)
    |> prune()
  end

  def one_step(secret) do
    secret
    |> mult(64)
    |> sdiv(32)
    |> mult(2048)
  end

  def get_ones(n) do
    rem(n, 10)
  end

  def differences(list) do
    list
    |> Enum.chunk(2, 1)
    |> Enum.map(fn [a, b] -> {b, b - a} end)
  end

  def parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1(args) do
    args
    |> parse()
    |> Enum.map(fn n ->
      Stream.iterate(n, &one_step/1)
      |> Enum.at(2000)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    possible_sales =
      args
      |> parse()
      |> Enum.map(fn n ->
        Stream.iterate(n, &one_step/1)
        |> Enum.slice(0, 2001)
        |> Enum.map(&get_ones/1)
        |> differences()
        |> Enum.chunk_every(4, 1, :discard)
        |> Enum.map(fn [{_na, a}, {_nb, b}, {_nc, c}, {nd, d}] ->
          {{a, b, c, d}, nd}
        end)
        |> Enum.reverse()
        |> Map.new()
      end)

    possible_sales
    |> Enum.map(&Map.keys/1)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.map(fn key ->
      totals =
        possible_sales
        |> Enum.map(fn sale_map ->
          Map.get(sale_map, key, 0)
        end)

      {key, totals |> Enum.sum()}
    end)
    |> Enum.max_by(fn {_key, value} -> value end)
    |> elem(1)
  end
end
