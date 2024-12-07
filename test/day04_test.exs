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

    assert Day04.part1(
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
    ) == 18
  end

  test "part2" do
    assert Day04.part2(
      """
        .M.S......
        ..A..MSMS.
        .M.S.MAA..
        ..A.ASMSM.
        .M.S.M....
        ..........
        S.S.S.S.S.
        .A.A.A.A..
        M.M.M.M.M.
        ..........
      """
    ) == 9
  end
end
