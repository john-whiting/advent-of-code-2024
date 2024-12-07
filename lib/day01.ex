defmodule Day01 do
    def parse_line(<<left::binary-size(5), "   ", right::binary-size(5), _rest::binary>>) do
        { Integer.parse(left) |> elem(0), Integer.parse(right) |> elem(0) }
    end

    def part1(input) do
        parsed_lines = Enum.map(input, &Day01.parse_line/1)
        {left, right} = Enum.unzip(parsed_lines)
        Enum.zip([Enum.sort(left), Enum.sort(right)])
            |> Enum.map(fn {left, right} -> abs(left - right) end )
            |> Enum.sum
    end

    def part2(input) do
        parsed_lines = Enum.map(input, &Day01.parse_line/1)
        {left, right} = Enum.unzip(parsed_lines)
        freqs = Enum.frequencies(right)
        Enum.map(left, &(&1 * Map.get(freqs, &1, 0)))
            |> Enum.sum
    end
end
