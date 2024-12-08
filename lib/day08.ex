defmodule AdventOfCode2024.Day08 do
  defmodule Grid do
    defstruct [:node_generator, :max_bounds, antinodes: MapSet.new(), antennas_by_freq: %{}]

    defp add_antinode(%Grid{ max_bounds: {yf, xf} }, {y, x}) when y > yf or y < 0 or x > xf or x < 0, do: :oob
    defp add_antinode(grid = %Grid{ antinodes: antinodes }, pos), do: Map.replace!(grid, :antinodes, MapSet.put(antinodes, pos))

    defp add_antinodes(grid, nil), do: grid
    defp add_antinodes(grid, next) do
      {pos, next} = next.()
      case add_antinode(grid, pos) do
        :oob -> grid
        grid -> add_antinodes(grid, next)
      end
    end

    defp generate_antinodes(grid = %Grid{node_generator: generator}, pos, diff), do: add_antinodes(grid, fn -> generator.(pos, diff) end)

    defp add_antinodes_between(grid, ant0 = {y0, x0}, ant1 = {y1, x1}) do
      diff = {dy, dx} = {y1 - y0, x1 - x0}
      generate_antinodes(grid, ant0, {-dy, -dx})
        |> generate_antinodes(ant1, diff)
    end

    defp add_antenna(grid = %Grid{antennas_by_freq: antennas_by_freq}, freq, pos) do
      antennas = Map.get(antennas_by_freq, freq, MapSet.new())
      Enum.reduce(antennas, grid, fn antenna, grid -> add_antinodes_between(grid, antenna, pos) end)
        |> Map.replace!(:antennas_by_freq, Map.put(antennas_by_freq, freq, MapSet.put(antennas, pos)))
    end

    defp add_antennas(grid, "", _), do: grid
    defp add_antennas(grid, << ".", rest::binary>>, {y, x}), do: add_antennas(grid, rest, {y, x + 1})
    defp add_antennas(grid, << freq::binary-size(1), rest::binary >>, pos = {y, x}) do
      add_antenna(grid, freq, pos) |> add_antennas(rest, {y, x + 1})
    end

    defp generate_grid(grid, rows, y \\ 0)
    defp generate_grid(grid, [], _), do: grid
    defp generate_grid(grid, [ row | tail ], y), do: add_antennas(grid, row, {y, 0}) |> generate_grid(tail, y + 1)

    def from_lines(rows, node_generator) when is_list(rows), do:
      %Grid{node_generator: node_generator, max_bounds: {length(rows) - 1, String.length(hd(rows)) - 1}}
        |> generate_grid(rows)
  end

  alias AdventOfCode2024.Day08.Grid, as: Grid
  alias AdventOfCode2024.Utils, as: Utils

  def repeat(pos = {y, x}, diff = {dy, dx}), do: {pos, fn -> repeat({y + dy, x + dx}, diff) end}
  def once({y, x}, {dy, dx}), do: {{y + dy, x + dx}, nil}

  def get_antinodes(input, generator) when is_binary(input) do
    Utils.lines(input)
      |> Enum.to_list()
      |> Grid.from_lines(generator)
      |> Map.get(:antinodes)
      |> Enum.count()
  end

  def part1(input) when is_binary(input), do: get_antinodes(input, &once/2)
  def part2(input) when is_binary(input), do: get_antinodes(input, &repeat/2)
end
