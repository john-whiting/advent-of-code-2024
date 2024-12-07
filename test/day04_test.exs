defmodule Day04Test do
  use ExUnit.Case
  alias AdventOfCode2024.Day04, as: Day04
  doctest AdventOfCode2024

  test "part1" do
    assert Day04.part1(
      """
        X..S
        .MA.
        .MA.
        X..S
      """
    ) == 2

    assert Day04.part1(example_input()) == 18
    assert Day04.part1(file_input()) == 2547
  end

  test "part2" do
    assert Day04.part2(example_input()) == 9
    assert Day04.part2(file_input()) == 1939
  end

  defp example_input() do
    """
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
    """
  end

  defp file_input() do
    File.read!("./specs/day04.txt")
  end
end
