defmodule Day09Test do
  use ExUnit.Case
  alias AdventOfCode2024.Day09, as: Day09
  doctest AdventOfCode2024

  def my_to_string(s) when is_binary(s), do: s
  def my_to_string(i) when is_integer(i), do: Integer.to_string(i)

  test "DiskMap from input" do
    disk_map = Day09.DiskMap.from_input(example_input())
    disk_map_str = disk_map.map |> Tuple.to_list() |> Enum.map(&my_to_string/1) |> List.to_string()
    assert disk_map_str == "00...111...2...333.44.5555.6666.777.888899"
  end

  test "swap_in_map" do
    disk_map = %Day09.DiskMap{map: {0, 0, 1, 1, 1, 2, 2, 3}}
    disk_map = Day09.DiskMap.swap_in_map(disk_map, 1..2, 5..6)
    assert disk_map.map == {0, 2, 2, 1, 1, 1, 0, 3}
  end

  test "part1" do
    assert Day09.part1(example_input()) == 1928
    assert Day09.part1(file_input()) == 6415184586041
  end

  test "part2" do
    assert Day09.part2(example_input()) == 2858
    assert Day09.part2(file_input()) == 6436819084274
  end

  defp example_input(), do: "2333133121414131402"

  defp file_input() do
    File.read!("./specs/day09.txt")
  end
end
