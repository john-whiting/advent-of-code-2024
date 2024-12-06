defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  test "bounds" do
    assert Day06.bounds({
      {0, 1},
      {0, 1},
    }) == {0, 0, 1, 1}
    assert Day06.bounds({
      {0, 1, 2},
      {0, 1, 2},
      {0, 1, 2},
    }) == {0, 0, 2, 2}
  end

  test "step up leave grid", do: assert Day06.step(:up, MapSet.new(), {0, 0, 10, 10}, {0, 5}) == MapSet.new([{0, 5}])
  test "step down leave grid", do: assert Day06.step(:down, MapSet.new(), {0, 0, 10, 10}, {10, 5}) == MapSet.new([{10, 5}])
  test "step left leave grid", do: assert Day06.step(:left, MapSet.new(), {0, 0, 10, 10}, {5, 0}) == MapSet.new([{5, 0}])
  test "step right leave grid", do: assert Day06.step(:right, MapSet.new(), {0, 0, 10, 10}, {5, 10}) == MapSet.new([{5, 10}])

  test "step is loop" do
    assert Day06.is_loop?(
      :up,
      MapSet.new([{0, 1}, {2, 0}, {1, 3}, {3, 2}]),
      {0, 0, 3, 3},
      {1, 1}
    ) == true
    assert Day06.is_loop?(
      :up,
      MapSet.new([{0, 1}, {1, 0}, {1, 3}, {3, 2}]),
      {0, 0, 3, 3},
      {1, 1}
    ) == false
  end

  test "build grid info" do
    {grid_bounds, blockers, pos} = Day06.build_grid_info(
      """
        .#..
        #^.#
        ....
        ..#.
      """
    )

    assert grid_bounds == {0, 0, 3, 3}
    assert MapSet.member?(blockers, {0, 1})
    assert MapSet.member?(blockers, {1, 0})
    assert MapSet.member?(blockers, {1, 3})
    assert MapSet.member?(blockers, {3, 2})
    assert pos == {1, 1}
  end

  test "part1" do
    assert Day06.part1(example_input()) == 41
    assert Day06.part1(file_input()) == 5177
  end
  test "part2" do
    assert Day06.part2(example_input()) == 6
    assert Day06.part2(file_input()) == 1686
  end

  defp example_input() do
    """
      ....#.....
      .........#
      ..........
      ..#.......
      .......#..
      ..........
      .#..^.....
      ........#.
      #.........
      ......#...
    """
  end

  defp file_input() do
    File.read!("./input.txt")
  end
end
