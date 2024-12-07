defmodule Benchmark do
  @doc """
  Returns time in milliseconds

  Modified from https://stackoverflow.com/a/29674651
  """
  def measure(function) do
    {uSec, result} = function |> :timer.tc
    {uSec / 1_000, result}
  end
end
