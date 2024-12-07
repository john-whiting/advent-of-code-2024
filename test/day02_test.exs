defmodule Day02Test do
  use ExUnit.Case
  alias AdventOfCode2024.Day02, as: Day02
  doctest AdventOfCode2024

  test "is_report_safe" do
    assert Day02.is_report_safe?([7, 6, 4, 2, 1]) == true
    assert Day02.is_report_safe?([1, 2, 7, 8, 9]) == false
    assert Day02.is_report_safe?([9, 7, 6, 2, 1]) == false
    assert Day02.is_report_safe?([1, 3, 2, 4, 5]) == false
    assert Day02.is_report_safe?([8, 6, 4, 4, 1]) == false
    assert Day02.is_report_safe?([1, 3, 6, 7, 9]) == true
  end

  test "is_dapened_report_safe" do
    assert Day02.is_dapened_report_safe?([7, 6, 4, 2, 1]) == true
    assert Day02.is_dapened_report_safe?([1, 2, 7, 8, 9]) == false
    assert Day02.is_dapened_report_safe?([9, 7, 6, 2, 1]) == false
    assert Day02.is_dapened_report_safe?([1, 3, 2, 4, 5]) == true
    assert Day02.is_dapened_report_safe?([8, 6, 4, 4, 1]) == true
    assert Day02.is_dapened_report_safe?([1, 3, 6, 7, 9]) == true
  end

  test "part1" do
    assert Day02.part1(file_input()) == 371
  end

  test "part2" do
    assert Day02.part2(file_input()) == 426
  end

  defp file_input() do
    File.read!("./specs/day02.txt")
  end
end
