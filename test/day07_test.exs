defmodule Day07Test do
  use ExUnit.Case
  alias AdventOfCode2024.Day07, as: Day07
  doctest AdventOfCode2024

  test "parse_line" do
    assert Day07.parse_line("190: 10 19") == {190, [10, 19]}
    assert Day07.parse_line("3267: 81 40 27") == {3267, [81, 40, 27]}
  end

  test "concat int" do
    assert Day07.concat_ints(10, 7) == 107
    assert Day07.concat_ints(10, 70) == 1070
    assert Day07.concat_ints(1, 70) == 170
    assert Day07.concat_ints(1, 99) == 199
    assert Day07.concat_ints(1, 9) == 19
    assert Day07.concat_ints(1, 10) == 110
  end

  test "test result" do
    {target, terms} = Day07.parse_line("190: 10 19")
    assert Day07.test_result(Day07.part1_tests(), target, terms)
    {target, terms} = Day07.parse_line("3267: 81 40 27")
    assert Day07.test_result(Day07.part1_tests(), target, terms)
    {target, terms} = Day07.parse_line("83: 17 5")
    assert not Day07.test_result(Day07.part1_tests(), target, terms)
  end

  test "part1" do
    assert Day07.part1(example_input()) == 3749
    assert Day07.part1(file_input()) == 2654749936343
  end

  test "part2" do
    assert Day07.part2(example_input()) == 11387
    assert Day07.part2(file_input()) == 124060392153684
  end

  defp example_input() do
    """
      190: 10 19
      3267: 81 40 27
      83: 17 5
      156: 15 6
      7290: 6 8 6 15
      161011: 16 10 13
      192: 17 8 14
      21037: 9 7 18 13
      292: 11 6 16 20
    """
  end

  defp file_input() do
    File.read!("./specs/day07.txt")
  end
end
