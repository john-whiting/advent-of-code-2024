defmodule AdventOfCode2024.Day10 do
  defmodule HikingGuide do
    @directions [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
    defstruct [:elements, :max_coord, trail_heads: []]

    def height_at(%HikingGuide{max_coord: {yf, xf}}, {y, x}) when y > yf or y < 0 or x > xf or x < 0, do: nil
    def height_at(%HikingGuide{elements: elements}, {y, x}), do: elements |> elem(y) |> elem(x)

    def score(guide = %HikingGuide{trail_heads: trail_heads}), do: Stream.map(trail_heads, &(score(guide, &1))) |> Stream.map(&MapSet.size/1) |> Enum.sum()

    defp score(guide, pos, cur_height \\ 0, prev_height \\ -1)
    defp score(%HikingGuide{max_coord: {yf, xf}}, {y, x}, _, _) when y > yf or y < 0 or x > xf or x < 0, do: MapSet.new()
    defp score(_, _, current_height, prev_height) when current_height != prev_height + 1, do: MapSet.new()
    defp score(_, pos, 9, _), do: MapSet.new([pos])
    defp score(guide = %HikingGuide{}, {y, x}, current_height, _) do
      Stream.flat_map(
        @directions,
        fn {dy, dx} ->
          next_pos = {y + dy, x + dx}
          score(guide, next_pos, height_at(guide, next_pos), current_height)
        end) |> Enum.filter(&(Kernel.!=(&1, nil))) |> MapSet.new()
    end

    def rating(guide = %HikingGuide{trail_heads: trail_heads}), do: Stream.map(trail_heads, &(rating(guide, &1))) |> Enum.sum()

    defp rating(guide, pos, cur_height \\ 0, prev_height \\ -1)
    defp rating(%HikingGuide{max_coord: {yf, xf}}, {y, x}, _, _) when y > yf or y < 0 or x > xf or x < 0, do: 0
    defp rating(_, _, current_height, prev_height) when current_height != prev_height + 1, do: 0
    defp rating(_, _, 9, _), do: 1
    defp rating(guide = %HikingGuide{}, {y, x}, current_height, _) do
      Stream.map(
        @directions,
        fn {dy, dx} ->
          next_pos = {y + dy, x + dx}
          rating(guide, next_pos, height_at(guide, next_pos), current_height)
        end) |> Enum.sum()
    end

    defp add_trail_heads(guide = %HikingGuide{max_coord: {yf, xf}}) do
      Map.replace!(
        guide,
        :trail_heads,
        Enum.reduce(0..(yf), [], fn row, acc ->
          Enum.reduce(0..(xf), acc, fn col, acc -> if height_at(guide, {row, col}) == 0, do: [{row, col} | acc], else: acc end)
        end)
      )
    end

    def from_lines(rows) when is_list(rows) do
      elements = Enum.map(rows, fn row -> String.graphemes(row) |> Enum.map(&String.to_integer/1) |> List.to_tuple end) |> List.to_tuple()
      max_coords = {tuple_size(elements) - 1, tuple_size(elem(elements, 0)) - 1}
      %HikingGuide { elements: elements, max_coord: max_coords } |> add_trail_heads()
    end
  end

  alias AdventOfCode2024.Day10.HikingGuide, as: HikingGuide
  alias AdventOfCode2024.Utils, as: Utils


  def part1(input) when is_binary(input) do
    Utils.lines(input)
      |> Enum.to_list()
      |> HikingGuide.from_lines()
      |> HikingGuide.score()
  end
  def part2(input) when is_binary(input) do
    Utils.lines(input)
      |> Enum.to_list()
      |> HikingGuide.from_lines()
      |> HikingGuide.rating()
  end
end
