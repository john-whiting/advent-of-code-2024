defmodule Mix.Tasks.Main do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {day, input_path} = List.to_tuple(args)
    input = File.read!(input_path)

    day_module = String.to_existing_atom("Elixir.AdventOfCode2024.#{day}")

    {part1_time, part1_result} = Benchmark.measure(fn -> apply(day_module, :part1, [input]) end)
    {part2_time, part2_result} = Benchmark.measure(fn -> apply(day_module, :part2, [input]) end)

    IO.puts("Part1 (completed in #{part1_time}ms): #{part1_result}")
    IO.puts("Part2 (completed in #{part2_time}ms): #{part2_result}")
  end
end
