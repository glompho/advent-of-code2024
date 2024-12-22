defmodule AdventOfCode.Day22Test do
  use ExUnit.Case

  import AdventOfCode.Day22

  test "mix test" do
    result = mix(15, 42)

    assert result == 37
  end

  test "prune test" do
    input = 100_000_000
    result = prune(input)
    assert result == 16_113_920
  end

  test "iterate test" do
    result =
      Stream.iterate(123, &one_step/1)
      |> Enum.take(11)

    assert result == [
             123,
             15_887_950,
             16_495_136,
             527_345,
             704_524,
             1_553_684,
             12_683_156,
             11_100_544,
             12_249_484,
             7_753_432,
             5_908_254
           ]
  end

  test "part1" do
    input = "1
10
100
2024"
    result = part1(input)

    assert result == 37_327_623
  end

  @tag :skip
  test "part2 small" do
    input = "123"
    result = part2(input)

    assert result == 6
  end

  test "part2" do
    input = "1
2
3
2024"
    result = part2(input)

    assert result == 23
  end
end
