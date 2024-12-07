defmodule AdventOfCode2024.Day03 do
  def op_mul(arg0, arg1, rest) when is_binary(arg0) and is_binary(arg1) and is_binary(rest) do
    arg0_int = Integer.parse(arg0) |> elem(0)
    arg1_int = Integer.parse(arg1) |> elem(0)

    {arg0_int * arg1_int, rest}
  end

  def kw_mul(<<"mul(", arg0::binary-size(1), ",", arg1::binary-size(1), ")", rest::binary>>), do: op_mul(arg0, arg1, rest)
  def kw_mul(<<"mul(", arg0::binary-size(1), ",", arg1::binary-size(2), ")", rest::binary>>), do: op_mul(arg0, arg1, rest)
  def kw_mul(<<"mul(", arg0::binary-size(1), ",", arg1::binary-size(3), ")", rest::binary>>), do: op_mul(arg0, arg1, rest)
  def kw_mul(<<"mul(", arg0::binary-size(2), ",", arg1::binary-size(1), ")", rest::binary>>), do: op_mul(arg0, arg1, rest)
  def kw_mul(<<"mul(", arg0::binary-size(2), ",", arg1::binary-size(2), ")", rest::binary>>), do: op_mul(arg0, arg1, rest)
  def kw_mul(<<"mul(", arg0::binary-size(2), ",", arg1::binary-size(3), ")", rest::binary>>), do: op_mul(arg0, arg1, rest)
  def kw_mul(<<"mul(", arg0::binary-size(3), ",", arg1::binary-size(1), ")", rest::binary>>), do: op_mul(arg0, arg1, rest)
  def kw_mul(<<"mul(", arg0::binary-size(3), ",", arg1::binary-size(2), ")", rest::binary>>), do: op_mul(arg0, arg1, rest)
  def kw_mul(<<"mul(", arg0::binary-size(3), ",", arg1::binary-size(3), ")", rest::binary>>), do: op_mul(arg0, arg1, rest)
  def kw_mul(input) when is_binary(input), do: {:no_match, input}

  def kw_do(<<"do()", rest::binary>>), do: {:match, rest}
  def kw_do(input) when is_binary(input), do: {:no_match, input}

  def kw_dont(<<"don't()", rest::binary>>), do: {:match, rest}
  def kw_dont(input) when is_binary(input), do: {:no_match, input}

  def shift(""), do: {:no_match, ""}
  def shift(<<_::binary-size(1), rest::binary>>), do: {:match, rest}



  def on_match({:no_match, rest}, func) when is_binary(rest) and is_function(func, 1), do: nil
  def on_match(result, func) when is_function(func, 1), do: func.(result)



  def parse_simple(input) when is_binary(input) do
    on_match(kw_mul(input), fn {result, rest} -> result + parse_simple(rest) end) ||
    on_match(shift(input), fn {_, rest} -> parse_simple(rest) end) ||
    0
  end

  def parse_disabled(input) when is_binary(input) do
    on_match(kw_do(input), fn {_, rest} -> parse_enabled(rest) end) ||
    on_match(shift(input), fn {_, rest} -> parse_disabled(rest) end) ||
    0
  end

  def parse_enabled(input) when is_binary(input) do
    on_match(kw_dont(input), fn {_, rest} -> parse_disabled(rest) end) ||
    on_match(kw_mul(input), fn {result, rest} -> result + parse_enabled(rest) end) ||
    on_match(shift(input), fn {_, rest} -> parse_enabled(rest) end) ||
    0
  end

  def part1(input) when is_binary(input), do: parse_simple(input)
  def part2(input) when is_binary(input), do: parse_enabled(input)
end
