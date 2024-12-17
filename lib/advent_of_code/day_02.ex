defmodule AdventOfCode.Day02 do
  def parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ")
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  def drop_elements(list) do
    Enum.map(0..(length(list) - 1), fn index ->
      List.delete_at(list, index)
    end)
  end

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ")
      |> Enum.map(&String.to_integer(&1))
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> a - b end)
    end)
    |> Enum.filter(fn list -> not Enum.any?(list, fn elem -> abs(elem) > 3 end) end)
    |> Enum.filter(fn list ->
      Enum.all?(list, fn elem -> elem > 0 end) || Enum.all?(list, fn elem -> elem < 0 end)
    end)
    |> Enum.count()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer(&1))
      |> drop_elements()
      |> Enum.map(fn dlist ->
        dlist
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [a, b] -> a - b end)
      end)
      |> Enum.filter(fn list -> not Enum.any?(list, fn elem -> abs(elem) > 3 end) end)
      |> Enum.filter(fn list ->
        Enum.all?(list, fn elem -> elem > 0 end) || Enum.all?(list, fn elem -> elem < 0 end)
      end)
      |> Enum.count()
    end)
    |> Enum.filter(fn num -> num > 0 end)
    |> Enum.count()
  end
end
