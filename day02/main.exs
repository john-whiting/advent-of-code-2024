defmodule Day02 do
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


    def part1(parsed_lines) do
      parsed_lines
        |> Stream.filter(&is_report_safe?/1)
        |> Enum.count
    end

    def part2(parsed_lines) do
      parsed_lines
        |> Stream.filter(&is_dapened_report_safe?/1)
        |> Enum.count
    end
end

true = Day02.is_report_safe?([7, 6, 4, 2, 1])
false = Day02.is_report_safe?([1, 2, 7, 8, 9])
false = Day02.is_report_safe?([9, 7, 6, 2, 1])
false = Day02.is_report_safe?([1, 3, 2, 4, 5])
false = Day02.is_report_safe?([8, 6, 4, 4, 1])
true = Day02.is_report_safe?([1, 3, 6, 7, 9])

true = Day02.is_dapened_report_safe?([7, 6, 4, 2, 1])
false = Day02.is_dapened_report_safe?([1, 2, 7, 8, 9])
false = Day02.is_dapened_report_safe?([9, 7, 6, 2, 1])
true = Day02.is_dapened_report_safe?([1, 3, 2, 4, 5])
true = Day02.is_dapened_report_safe?([8, 6, 4, 4, 1])
true = Day02.is_dapened_report_safe?([1, 3, 6, 7, 9])


parsed_lines = File.stream!("./input.txt")
  |> Enum.map(&Day02.parse_line/1)

parsed_lines
  |> Day02.part1
  |> IO.puts

parsed_lines
    |> Day02.part2
    |> IO.puts
