defmodule AdventOfCode2024.Day08 do
  alias AdventOfCode2024.Utils, as: Utils

  def harmonics(antinodes, {yf, xf}, {y, x}, _) when y > yf or y < 0 or x > xf or x < 0, do: antinodes
  def harmonics(antinodes, max_bounds, pos = {y, x}, diff = {dy, dx}) do
    MapSet.put(antinodes, pos)
      |> harmonics(max_bounds, {y + dy, x + dx}, diff)
  end

  def add_antinode(antinodes, {yf, xf}, {y, x}) when y > yf or y < 0 or x > xf or x < 0, do: antinodes
  def add_antinode(antinodes, _, pos), do: MapSet.put(antinodes, pos)

  def get_antinodes(antinodes, max_bounds, pos0 = {y0, x0}, pos1 = {y1, x1}, repeat) do
    {dy, dx} = {y1 - y0, x1 - x0}
    if repeat == :repeat do
      harmonics(antinodes, max_bounds, pos0, {-dy, -dx})
        |> harmonics(max_bounds, pos1, {dy, dx})
    else
      add_antinode(antinodes, max_bounds, {y0 - dy, x0 - dx})
        |> add_antinode(max_bounds, {y1 + dy, x1 + dx})
    end
  end

  def get_antinode_cols("", _, _, antinodes, antennas, _), do: {antinodes, antennas}
  def get_antinode_cols(<< ".", rest::binary>>, max_bounds, {y, x}, antinodes, antennas, repeat), do: get_antinode_cols(rest, max_bounds, {y, x + 1}, antinodes, antennas, repeat)
  def get_antinode_cols(<< char::binary-size(1), rest::binary >>, max_bounds, pos = {y, x}, antinodes, antennas, repeat) do
    existing_antennas = Map.get(antennas, char, MapSet.new())
    antinodes = Enum.reduce(
      existing_antennas,
      antinodes,
      fn antenna_pos, antinodes ->
        get_antinodes(antinodes, max_bounds, antenna_pos, pos, repeat)
      end
    )
    antennas = Map.put(antennas, char, MapSet.put(existing_antennas, pos))
    get_antinode_cols(rest, max_bounds, {y, x + 1}, antinodes, antennas, repeat)
  end

  def get_antinodes(grid, max_bounds, repeat, y \\ 0, antinodes \\ MapSet.new(), antennas \\ %{})
  def get_antinodes([], _, _, _, antinodes, _), do: antinodes
  def get_antinodes([ row | tail ], max_bounds, repeat, y, antinodes, antennas) do
    {antinodes, antennas} = get_antinode_cols(row, max_bounds, {y, 0}, antinodes, antennas, repeat)
    get_antinodes(tail, max_bounds, repeat, y + 1, antinodes, antennas)
  end

  def part1(input) when is_binary(input) do
    grid = Utils.lines(input)
      |> Enum.to_list()

    get_antinodes(grid, {length(grid) - 1, String.length(hd(grid)) - 1}, :no)
      |> Enum.count()
  end

  def part2(input) when is_binary(input) do
    grid = Utils.lines(input)
      |> Enum.to_list()

    get_antinodes(grid, {length(grid) - 1, String.length(hd(grid)) - 1}, :repeat)
      |> Enum.count()
  end
end
