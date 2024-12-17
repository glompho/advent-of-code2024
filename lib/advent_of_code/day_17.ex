defmodule AdventOfCode.Day17 do
  def combo(n, a, b, c) do
    case n do
      0 -> 0
      1 -> 1
      2 -> 2
      3 -> 3
      4 -> a
      5 -> b
      6 -> c
      7 -> {:error, "7 no op!"}
    end
  end

  def adv(n, a, b, c) do
    result = div(a, 2 ** combo(n, a, b, c))
    {result, b, c}
  end

  def bxl(n, a, b, c) do
    result = Bitwise.bxor(b, n)
    {a, result, c}
  end

  def bst(n, a, b, c) do
    result = Integer.mod(combo(n, a, b, c), 8)
    {a, result, c}
  end

  def jnz(n, a, _b, _c, pointer) do
    if a == 0 do
      pointer + 2
    else
      n
    end
  end

  def bxc(_n, a, b, c) do
    result = Bitwise.bxor(b, c)
    {a, result, c}
  end

  def out(n, a, b, c) do
    Integer.mod(combo(n, a, b, c), 8)
  end

  def bdv(n, a, b, c) do
    result = div(a, 2 ** combo(n, a, b, c))
    {a, result, c}
  end

  def cdv(n, a, b, c) do
    result = div(a, 2 ** combo(n, a, b, c))
    {a, b, result}
  end

  def one_command(op, n, a, b, c, pointer) do
    case op do
      0 ->
        adv(n, a, b, c)

      1 ->
        bxl(n, a, b, c)

      2 ->
        bst(n, a, b, c)

      3 ->
        # IO.inspect({"JUMP", a, jnz(n, a, b, c, 0)})
        {:jump, jnz(n, a, b, c, pointer)}

      4 ->
        bxc(n, a, b, c)

      5 ->
        {:output, out(n, a, b, c)}

      6 ->
        bdv(n, a, b, c)

      7 ->
        cdv(n, a, b, c)
    end
  end

  def run_program({a, b, c}, pointer, output, program) do
    if pointer >= length(program) do
      final_output =
        output
        |> Enum.map(&Integer.to_string/1)
        |> Enum.join(",")

      {{a, b, c}, pointer, final_output}
    else
      [op, n] = Enum.slice(program, pointer, 2)
      # IO.inspect({op, n, a, b, c, pointer})

      case one_command(op, n, a, b, c, pointer) do
        {:jump, new_p} -> run_program({a, b, c}, new_p, output, program)
        {:output, new_o} -> run_program({a, b, c}, pointer + 2, output ++ [new_o], program)
        {na, nb, nc} -> run_program({na, nb, nc}, pointer + 2, output, program)
      end
    end
  end

  def parse(input) do
    input
    |> String.split(
      [
        "Register A: ",
        "Register B: ",
        "Register C: ",
        "Program: ",
        ",",
        "\n"
      ],
      trim: true
    )
    |> Enum.map(&String.to_integer/1)
  end

  def part1(input) do
    [a, b, c | program] = parse(input)

    {{_, _, _}, _, output} = run_program({a, b, c}, 0, [], program)

    output
  end

  def part2(input) do
    [a, b, c | program] = parse(input)
    program_string = Enum.join(program, ",")
    IO.inspect(program_string)

    n =
      Enum.take_while(Stream.iterate(0, &(&1 + 1)), fn x ->
        {{_, _, _}, _, output} = run_program({x, b, c}, 0, [], program)
        output != program_string
        # IO.inspect({output, program_string, x})
      end)
      |> Enum.count()
  end
end
