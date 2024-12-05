defmodule Day04 do
  def mas({<<"M", _::binary-size(1), "M">>, <<_::binary-size(1), "A", _::binary>>, <<"S", _::binary-size(1), "S">>}), do: 1
  def mas({<<"M", _::binary-size(1), "S">>, <<_::binary-size(1), "A", _::binary>>, <<"M", _::binary-size(1), "S">>}), do: 1
  def mas({<<"S", _::binary-size(1), "M">>, <<_::binary-size(1), "A", _::binary>>, <<"S", _::binary-size(1), "M">>}), do: 1
  def mas({<<"S", _::binary-size(1), "S">>, <<_::binary-size(1), "A", _::binary>>, <<"M", _::binary-size(1), "M">>}), do: 1
  def mas(_), do: 0

  def xmas(input) when is_tuple(input) do
    (if match?({"XMAS", _, _, _}, input), do: 1, else: 0) +
    (if match?({"SAMX", _, _, _}, input), do: 1, else: 0) +
    (if match?({<<"X", _::binary>>, <<"M", _::binary>>, <<"A", _::binary>>, <<"S", _::binary>>}, input), do: 1, else: 0) +
    (if match?({<<"S", _::binary>>, <<"A", _::binary>>, <<"M", _::binary>>, <<"X", _::binary>>}, input), do: 1, else: 0) +
    (if match?({<<"X", _::binary>>, <<_::binary-size(1), "M", _::binary>>, <<_::binary-size(2), "A", _::binary>>, <<_::binary-size(3), "S">>}, input), do: 1, else: 0) +
    (if match?({<<"S", _::binary>>, <<_::binary-size(1), "A", _::binary>>, <<_::binary-size(2), "M", _::binary>>, <<_::binary-size(3), "X">>}, input), do: 1, else: 0) +
    (if match?({<<_::binary-size(3), "X">>, <<_::binary-size(2), "M", _::binary>>, <<_::binary-size(1), "A", _::binary>>, <<"S", _::binary>>}, input), do: 1, else: 0) +
    (if match?({<<_::binary-size(3), "S">>,<<_::binary-size(2), "A", _::binary>>,<<_::binary-size(1), "M", _::binary>>,<<"X", _::binary>>}, input), do: 1, else: 0)
  end

  def chunk_every_2d(grid, count, step, filler \\ "-") when is_list(grid) and is_integer(count) and is_integer(step) do
    filler_cols = List.duplicate(filler, count - 1)
    grid_filled_cols = grid |> Enum.map(&(&1 ++ filler_cols))
    row_length = grid_filled_cols |> hd |> length
    filler_rows = List.duplicate(List.duplicate(filler, row_length), count - 1)
    Enum.chunk_every(grid_filled_cols ++ filler_rows, count, step, :discard)
      |> Enum.flat_map(fn rows ->
          Enum.map(rows, fn row ->
            Enum.chunk_every(row, count, step, :discard)
              |> Enum.map(&List.to_string/1)
          end)
            |> Enum.zip
        end)
  end

  def part1(lines) do
    lines
      |> Enum.map(&String.graphemes/1)
      |> Day04.chunk_every_2d(4, 1, ".")
      |> Stream.map(&xmas/1)
      |> Enum.sum
  end

  def part2(lines) do
    lines
      |> Enum.map(&String.graphemes/1)
      |> Day04.chunk_every_2d(3, 1, ".")
      |> Stream.map(&mas/1)
      |> Enum.sum
  end
end


18 = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
""" |> String.split |> Day04.part1

2 = """
X..S
.MA.
.MA.
X..S
""" |> String.split |> Day04.part1

9 = """
.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
..........
""" |> String.split |> Day04.part2

input = File.stream!("./input.txt")
  |> Enum.map(&String.trim/1)

Day04.part1(input) |> IO.puts
Day04.part2(input) |> IO.puts
