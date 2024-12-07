defmodule AdventOfCode2024.Day07 do
  def parse_line(line) when is_binary(line) do
    case Integer.parse(line) do
      {int, <<": ", rest::binary>>} -> {int, parse_line(rest)}
      {int, <<" ", rest::binary>>} -> [int | parse_line(rest)]
      {int, ""} -> [int]
    end
  end

  def test_result(test_funcs, target, terms, total \\ nil)
  def test_result(_, target, [], total), do: target == total
  def test_result(test_funcs, target, [head | tail], nil), do: test_result(test_funcs, target, tail, head)
  def test_result(test_funcs, target, [head | tail], total) when is_integer(target) and is_integer(head) do
    Enum.any?(test_funcs, fn func -> test_result(test_funcs, target, tail, func.(total, head)) end)
  end

  def evaluate(input, filter) when is_binary(input) do
    String.trim(input)
      |> String.split(["\n", "\r", "\r\n"])
      |> Stream.map(&String.trim/1)
      |> Stream.map(&parse_line/1)
      |> Stream.filter(filter)
      |> Stream.map(&(elem(&1, 0)))
      |> Enum.sum()
  end

  def concat_ints(a, b) when is_integer(a) and is_integer(b) do
    a * Math.pow(10, ceil(Math.log10(b + 1))) + b
  end

  def part1_tests(), do: [&Kernel.+/2, &Kernel.*/2]
  def part2_tests(), do: [&concat_ints/2 | part1_tests()] |> Enum.reverse()

  def part1(input) when is_binary(input), do: evaluate(input, &(test_result(part1_tests(), elem(&1, 0), elem(&1, 1))))
  def part2(input) when is_binary(input), do: evaluate(input, &(test_result(part2_tests(), elem(&1, 0), elem(&1, 1))))
end
