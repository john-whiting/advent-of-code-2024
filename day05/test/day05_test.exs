defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  test "parsed 48|18" do
    assert Day05.parse_rule("48|18") == {48, 18}
  end

  test "parse_rules" do
    rules = """
      48|18
      22|59
      22|85
    """
    assert Day05.parse_rules(rules) == %{48 => MapSet.new([18]), 22 => MapSet.new([59, 85])}
  end

  test "parsed 35,58,32,63,89,99,72,79,68" do
    assert Day05.parse_update("35,58,32,63,89,99,72,79,68") == [35,58,32,63,89,99,72,79,68]
  end

  test "parse_updates" do
    updates = """
      35,58,32,63,89,99,72,79,68
      86,51,18,55,24,17,65,14,26,54,41,47,97,69,19,36,42,85,98
    """
    assert Day05.parse_updates(updates) == [[35,58,32,63,89,99,72,79,68], [86,51,18,55,24,17,65,14,26,54,41,47,97,69,19,36,42,85,98]]
  end

  test "is_correct" do
    rules = example_rules()
    assert Day05.is_correct(rules, [75,47,61,53,29]) == true
    assert Day05.is_correct(rules, [97,61,53,29,13]) == true
    assert Day05.is_correct(rules, [75,29,13]) == true
    assert Day05.is_correct(rules, [75,97,47,61,53]) == false
    assert Day05.is_correct(rules, [61,13,29]) == false
    assert Day05.is_correct(rules, [97,13,75,29,47]) == false
  end

  test "correct_updates" do
    rules = example_rules()
    assert Day05.correct_updates(rules, [75,97,47,61,53]) == [97,75,47,61,53]
    assert Day05.correct_updates(rules, [61,13,29]) == [61,29,13]
    assert Day05.correct_updates(rules, [97,13,75,29,47]) == [97,75,47,29,13]
  end

  test "part1" do
    assert Day05.part1(example_input()) == 143
    assert Day05.part1(file_input()) == 5509
  end

  test "part2" do
    assert Day05.part2(example_input()) == 123
    assert Day05.part2(file_input()) == 4407
  end

  defp example_rules(), do: Day05.parse_rules(
    example_input() |> String.split("\n\n") |> hd
  )

  defp example_input() do
  """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
  """
  end

  defp file_input() do
    File.read!("./input.txt")
  end
end
