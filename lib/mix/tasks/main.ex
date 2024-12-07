defmodule Mix.Tasks.Main do
  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    input = File.read!("./input.txt")
    IO.puts("Part1: #{Day06.part1(input)}")
    IO.puts("Part2: #{Day06.part2(input)}")
  end
end
