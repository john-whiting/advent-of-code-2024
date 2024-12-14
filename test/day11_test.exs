defmodule Day11Test do
  use ExUnit.Case
  alias AdventOfCode2024.Day11, as: Day11
  doctest AdventOfCode2024

  test "part1" do
    assert Day11.part1(example_input()) == 55312
    assert Day11.part1(file_input()) == 229043
  end

  test "part2" do
    assert Day11.part2(file_input()) == 272673043446478
  end

  defp example_input() do
    """
      125 17
    """
  end

  defp file_input() do
    File.read!("./specs/day11.txt")
  end
end
