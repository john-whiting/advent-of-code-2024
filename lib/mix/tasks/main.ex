defmodule Mix.Tasks.Main do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {day, input_path} = List.to_tuple(args)
    input = File.read!(input_path)

    day_module = String.to_existing_atom("Elixir.AdventOfCode2024.#{day}")

    part1_result = apply(day_module, :part1, [input])
    part2_result = apply(day_module, :part2, [input])

    IO.puts("Part1: #{part1_result}")
    IO.puts("Part2: #{part2_result}")
  end
end
