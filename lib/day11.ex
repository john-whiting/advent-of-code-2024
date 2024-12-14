defmodule AdventOfCode2024.Day11 do
  require Integer
  use Memoize

  def has_even_digits(num) when is_integer(num), do: Math.log10(num) |> floor() |> Integer.is_odd()

  defmemo apply_rule(stone) do
    if stone == 0 do
      1
    else
      if has_even_digits(stone) do
        stone = Integer.to_string(stone)
        {first, second} = String.split_at(stone, String.length(stone) |> Integer.floor_div(2))
        {String.to_integer(first), String.to_integer(second)}
      else
        stone * 2024
      end
    end
  end

  defmemo blink_stone(_, 0), do: 1
  defmemo blink_stone(stone, depth) do
    case apply_rule(stone) do
      {first, second} -> blink_stone(first, depth - 1) + blink_stone(second, depth - 1)
      stone -> blink_stone(stone, depth - 1)
    end
  end

  def blink([], _), do: 0
  def blink([head | tail], depth) when is_integer(head) do
    blink_stone(head, depth) + blink(tail, depth)
  end

  def part1(input) when is_binary(input) do
    String.trim(input)
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> blink(25)
  end
  def part2(input) when is_binary(input) do
    String.trim(input)
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> blink(75)
  end
end
