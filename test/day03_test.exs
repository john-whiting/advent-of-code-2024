defmodule Day03Test do
  use ExUnit.Case
  alias AdventOfCode2024.Day03, as: Day03
  doctest AdventOfCode2024

  test "part1" do
    assert Day03.part1("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))") == 161
    assert Day03.part1(file_input()) == 174336360
  end

  test "part2" do
    assert Day03.part2("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))") == 48
    assert Day03.part2(file_input()) == 88802350
  end

  defp file_input() do
    File.read!("./specs/day03.txt")
  end
end
