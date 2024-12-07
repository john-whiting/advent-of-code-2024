defmodule AdventOfCode2024.Day02 do
    def parse_line("") do
      []
    end

    def parse_line(line) when is_binary(line) do
      {level, rest} = line |> String.trim |> Integer.parse()
      [level | parse_line(rest)]
    end

    def is_report_ordered?(report) do
      sorted = Enum.sort(report)

      report == sorted || report == Enum.reverse(sorted)
    end



    def is_within_threshold?([]), do: true
    def is_within_threshold?([_]), do: true
    def is_within_threshold?([head, second | tail]) do
      difference = abs(head - second)
      difference > 0 && difference <= 3 && is_within_threshold?([second | tail])
    end



    def is_report_safe?(report), do: (is_report_ordered?(report) && is_within_threshold?(report))



    def is_dapened_report_safe?(report) do
      (0..(length(report) - 1)) |> Enum.any?(fn idx -> List.delete_at(report, idx) |> is_report_safe? end)
    end


    def part1(input) do
      String.split(input, ["\n", "\r", "\r\n"])
        |> Stream.map(&parse_line/1)
        |> Stream.filter(&is_report_safe?/1)
        |> Enum.count
    end

    def part2(input) do
      String.split(input, ["\n", "\r", "\r\n"])
        |> Stream.map(&parse_line/1)
        |> Stream.filter(&is_dapened_report_safe?/1)
        |> Enum.count
    end
end
