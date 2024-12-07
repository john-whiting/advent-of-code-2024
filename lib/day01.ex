defmodule AdventOfCode2024.Day01 do
    def parse_line(<<left::binary-size(5), "   ", right::binary-size(5), _rest::binary>>) do
        { Integer.parse(left) |> elem(0), Integer.parse(right) |> elem(0) }
    end

    def part1(input) do
        {left, right} = String.split(input, ["\n", "\r", "\r\n"])
            |> Stream.map(&parse_line/1)
            |> Enum.unzip()
        Stream.zip([Enum.sort(left), Enum.sort(right)])
            |> Stream.map(fn {left, right} -> abs(left - right) end )
            |> Enum.sum
    end

    def part2(input) do
        {left, right} = String.split(input, ["\n", "\r", "\r\n"])
            |> Stream.map(&parse_line/1)
            |> Enum.unzip()
        freqs = Enum.frequencies(right)
        Stream.map(left, &(&1 * Map.get(freqs, &1, 0)))
            |> Enum.sum
    end
end
