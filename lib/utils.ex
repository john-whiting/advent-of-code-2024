defmodule AdventOfCode2024.Utils do
  def lines(input) when is_binary(input) do
    String.trim(input)
      |> String.split(["\n", "\r", "\r\n"])
      |> Stream.map(&String.trim/1)
  end
end
