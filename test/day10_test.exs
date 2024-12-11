defmodule Day10Test do
  use ExUnit.Case
  alias AdventOfCode2024.Day10, as: Day10
  doctest AdventOfCode2024

  test "part1" do
    assert Day10.part1(example_input()) == 36
    assert Day10.part1(file_input()) == 552
  end

  test "part2" do
    assert Day10.part2(example_input()) == 81
    assert Day10.part2(file_input()) == 1225
  end

  defp example_input() do
    """
      89010123
      78121874
      87430965
      96549874
      45678903
      32019012
      01329801
      10456732

    """
  end

  defp file_input() do
    File.read!("./specs/day10.txt")
  end
end
