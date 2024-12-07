defmodule AdventOfCode2024.Day05 do
  def parse_rule(line) when is_binary(line) do
    {bef, <<"|", line::binary>>} = Integer.parse(line)
    {aft, _} = Integer.parse(line)
    {bef, aft}
  end
  def parse_rules(rules) when is_binary(rules), do: String.trim(rules) |> String.split |> parse_rules
  def parse_rules(rule_lines) when is_list(rule_lines) do
    Stream.map(rule_lines, &parse_rule/1)
      |> Enum.group_by(&(elem(&1, 0)), &(elem(&1, 1)))
      |> Enum.into(%{}, fn {k, v} -> {k, MapSet.new(v)} end)
  end


  def parse_update(line) when is_binary(line), do: String.split(line, ",") |> Enum.map(&String.to_integer/1)
  def parse_updates(updates) when is_binary(updates), do: String.trim(updates) |> String.split |> parse_updates
  def parse_updates(update_lines) when is_list(update_lines), do: Enum.map(update_lines, &parse_update/1)

  def is_correct(rules, update, seen_values \\ MapSet.new())
  def is_correct(_, [], _), do: true
  def is_correct(rules, [head | tail], seen_values) do
    after_numbers = Map.get(rules, head, MapSet.new())
    if MapSet.disjoint?(seen_values, after_numbers) do
      is_correct(rules, tail, MapSet.put(seen_values, head))
    else
      false
    end
  end

  def correct_updates(rules, updates) when is_map(rules) and is_list(updates) do
    Enum.sort(updates, fn first, second ->
      after_numbers = Map.get(rules, first, MapSet.new())
      MapSet.member?(after_numbers, second)
    end)
  end

  def split_input(input_str) when is_binary(input_str), do: String.split(input_str, "\n\n") |> List.to_tuple

  def part1(input_str) when is_binary(input_str) do
    {rules, updates} = split_input(input_str)
    rules = parse_rules(rules)
    updates = parse_updates(updates)

    Stream.filter(updates, &(is_correct(rules, &1)))
      |> Stream.map(&(Enum.at(&1, div(length(&1), 2))))
      |> Enum.sum
  end

  def part2(input_str) when is_binary(input_str) do
    {rules, updates} = split_input(input_str)
    rules = parse_rules(rules)
    updates = parse_updates(updates)

    Stream.filter(updates, &(not is_correct(rules, &1)))
      |> Stream.map(&(correct_updates(rules, &1)))
      |> Stream.map(&(Enum.at(&1, div(length(&1), 2))))
      |> Enum.sum
  end
end
