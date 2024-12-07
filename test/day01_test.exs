defmodule Day01Test do
  use ExUnit.Case
  alias AdventOfCode2024.Day01, as: Day01
  doctest AdventOfCode2024

  test "part1" do
    assert Day01.part1(file_input()) == 3574690
  end

  test "part2" do
    assert Day01.part2(file_input()) == 22565391
  end

  defp file_input() do
    File.read!("./specs/day01.txt")
  end
end
