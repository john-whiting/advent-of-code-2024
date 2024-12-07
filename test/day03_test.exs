defmodule Day03Test do
  use ExUnit.Case
  doctest AdventOfCode2024

  test "part1" do
    assert Day03.part1("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))") == 161
  end

  test "part2" do
    assert Day03.part2("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))") == 48
  end
end
