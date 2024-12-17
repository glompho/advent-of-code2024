defmodule AdventOfCode.Day04 do
  def part1(args) do
    grid =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    Enum.map(Enum.with_index(grid), fn {line, y} ->
      Enum.map(Enum.with_index(line), fn {cell, x} ->
        case cell do
          "X" -> count_from_x(x, y, grid)
          _ -> 0
        end
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  def count_from_x(x, y, grid) do
    [{0, 1}, {0, -1}, {1, 0}, {1, -1}, {1, 1}, {-1, 0}, {-1, 1}, {-1, -1}]
    |> Enum.map(fn {dx, dy} -> check_direction(x, y, dx, dy, grid) end)
    |> Enum.sum()
  end

  def check_direction(x, y, dx, dy, grid) do
    grid_height = length(grid)
    grid_width = length(hd(grid))

    "XMAS"
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(1, fn {char, index}, acc ->
      new_x = x + dx * index
      new_y = y + dy * index

      if new_x < 0 or new_y < 0 or new_x >= grid_width or new_y >= grid_height do
        acc * 0
      else
        in_grid = Enum.at(Enum.at(grid, new_y), new_x)

        if char == in_grid do
          acc * 1
        else
          acc * 0
        end
      end
    end)
  end

  def part2(args) do
    grid =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    Enum.map(Enum.with_index(grid), fn {line, y} ->
      Enum.map(Enum.with_index(line), fn {cell, x} ->
        case cell do
          "A" -> check_MAS(x, y, grid)
          _ -> 0
        end
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  def check_MAS(x, y, grid) do
    grid_height = length(grid)
    grid_width = length(hd(grid))

    cross =
      [{-1, -1}, {1, 1}, {-1, 1}, {1, -1}]
      |> Enum.map(fn {dx, dy} ->
        new_x = x + dx
        new_y = y + dy

        if new_x < 0 or new_y < 0 or new_x >= grid_width or new_y >= grid_height do
          ""
        else
          Enum.at(Enum.at(grid, y + dy), x + dx)
        end
      end)

    if Enum.member?(["SMSM", "SMMS", "MSMS", "MSSM"], Enum.join(cross)), do: 1, else: 0
  end
end
