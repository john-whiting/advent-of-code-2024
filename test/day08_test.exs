defmodule Day08Test do
  use ExUnit.Case
  alias AdventOfCode2024.Day08, as: Day08
  doctest AdventOfCode2024

  test "part1" do
    assert Day08.part1(
      """
      ...
      .A.
      ..A
      ...
      """
    ) == 1
    assert Day08.part1(example_input()) == 14
    assert Day08.part1(file_input()) == 364
  end

  test "part2" do
    assert Day08.part2(example_input()) == 34
    assert Day08.part2(file_input()) == 1231
  end

  defp example_input() do
    """
      ............
      ........0...
      .....0......
      .......0....
      ....0.......
      ......A.....
      ............
      ............
      ........A...
      .........A..
      ............
      ............
    """
  end

  defp file_input() do
    File.read!("./specs/day08.txt")
  end
end
