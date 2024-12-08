defmodule AdventOfCode2024.Day08 do
  alias AdventOfCode2024.Utils, as: Utils

  def harmonics(antinodes, {yf, xf}, {y, x}, _) when y > yf or y < 0 or x > xf or x < 0, do: antinodes
  def harmonics(antinodes, max_bounds, pos = {y, x}, diff = {dy, dx}) do
    MapSet.put(antinodes, pos)
      |> harmonics(max_bounds, {y + dy, x + dx}, diff)
  end

  def pos_offset(antinodes, {yf, xf}, {y, x}, {dy, dx}) do
    new_pos = {yn, xn} = {y + dy, x + dx}
    if yf >= yn and yn >= 0 and xf >= xn and xn >= 0, do: MapSet.put(antinodes, new_pos), else: antinodes
  end

  def get_antinodes(antinodes, max_bounds, add_antinodes, pos0 = {y0, x0}, pos1 = {y1, x1}) do
    {dy, dx} = {y1 - y0, x1 - x0}
    add_antinodes.(antinodes, max_bounds, pos0, {-dy, -dx})
      |> add_antinodes.(max_bounds, pos1, {dy, dx})
  end

  def get_antinode_cols("", _, _, _, antinodes, antennas), do: {antinodes, antennas}
  def get_antinode_cols(<< ".", rest::binary>>, max_bounds, add_antinodes, {y, x}, antinodes, antennas), do: get_antinode_cols(rest, max_bounds, add_antinodes, {y, x + 1}, antinodes, antennas)
  def get_antinode_cols(<< char::binary-size(1), rest::binary >>, max_bounds, add_antinodes, pos = {y, x}, antinodes, antennas) do
    existing_antennas = Map.get(antennas, char, MapSet.new())
    antinodes = Enum.reduce(
      existing_antennas,
      antinodes,
      fn antenna_pos, antinodes ->
        get_antinodes(antinodes, max_bounds, add_antinodes, antenna_pos, pos)
      end
    )
    antennas = Map.put(antennas, char, MapSet.put(existing_antennas, pos))
    get_antinode_cols(rest, max_bounds, add_antinodes, {y, x + 1}, antinodes, antennas)
  end

  def get_antinodes(grid, max_bounds, add_antinodes, y \\ 0, antinodes \\ MapSet.new(), antennas \\ %{})
  def get_antinodes([], _, _, _, antinodes, _), do: antinodes
  def get_antinodes([ row | tail ], max_bounds, add_antinodes, y, antinodes, antennas) do
    {antinodes, antennas} = get_antinode_cols(row, max_bounds, add_antinodes, {y, 0}, antinodes, antennas)
    get_antinodes(tail, max_bounds, add_antinodes, y + 1, antinodes, antennas)
  end

  def part1(input) when is_binary(input) do
    grid = Utils.lines(input)
      |> Enum.to_list()

    get_antinodes(grid, {length(grid) - 1, String.length(hd(grid)) - 1}, &pos_offset/4)
      |> Enum.count()
  end

  def part2(input) when is_binary(input) do
    grid = Utils.lines(input)
      |> Enum.to_list()

    get_antinodes(grid, {length(grid) - 1, String.length(hd(grid)) - 1}, &harmonics/4)
      |> Enum.count()
  end
end
