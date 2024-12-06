defmodule Day06 do
  @next_direction %{:up => :right, :down => :left, :left => :up, :right => :down}

  def bounds(grid) when is_tuple(grid) do
    {0, 0, tuple_size(grid) - 1, tuple_size(elem(grid, 0)) - 1}
  end

  def first_visit(visits, pos), do: (if Map.has_key?(visits, pos), do: 0, else: 1)

  def next_pos(:up, {y, x}), do: {y - 1, x}
  def next_pos(:down, {y, x}), do: {y + 1, x}
  def next_pos(:left, {y, x}), do: {y, x - 1}
  def next_pos(:right, {y, x}), do: {y, x + 1}

  # Base cases of stepping out of the grid
  def step(:up, visits, _, {y, _, _, _}, {y, x}) when is_integer(y), do: first_visit(visits, {y, x})
  def step(:down, visits, _, {_, _, y, _}, {y, x}) when is_integer(y), do: first_visit(visits, {y, x})
  def step(:left, visits, _, {_, x, _, _}, {y, x}) when is_integer(x), do: first_visit(visits, {y, x})
  def step(:right, visits, _, {_, _, _, x}, {y, x}) when is_integer(x), do: first_visit(visits, {y, x})
  def step(direction, visits, blockers, grid_bounds, pos) when is_atom(direction) do
    next = next_pos(direction, pos)
    if MapSet.member?(blockers, next) do
      step(@next_direction[direction], visits, blockers, grid_bounds, pos)
    else
      first_visit(visits, pos) + step(direction, Map.put(visits, pos, direction), blockers, grid_bounds, next)
    end
  end

  # Base cases of stepping out of the grid
  def step_is_loop(:up, _, _, {y, _, _, _}, {y, _}) when is_integer(y), do: false
  def step_is_loop(:down, _, _, {_, _, y, _}, {y, _}) when is_integer(y), do: false
  def step_is_loop(:left, _, _, {_, x, _, _}, {_, x}) when is_integer(x), do: false
  def step_is_loop(:right, _, _, {_, _, _, x}, {_, x}) when is_integer(x), do: false
  def step_is_loop(direction, visits, blockers, grid_bounds, pos) when is_atom(direction) do
    next = next_pos(direction, pos)
    directions_visited = Map.get(visits, pos, MapSet.new())

    if MapSet.member?(directions_visited, direction) do
      true
    else
      new_visits = Map.put(visits, pos, MapSet.put(directions_visited, direction))
      if MapSet.member?(blockers, next) do
        step_is_loop(@next_direction[direction], new_visits, blockers, grid_bounds, pos)
      else
        step_is_loop(direction, new_visits, blockers, grid_bounds, next)
      end
    end
  end

  def build_grid_info(input) when is_binary(input) do
    grid = String.trim(input)
      |> String.split
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.graphemes/1)
      |> Enum.map(&List.to_tuple/1)
      |> List.to_tuple

    grid_bounds = bounds(grid)
    {y0, x0, yf, xf} = grid_bounds
    {blockers, pos} = Enum.reduce(y0..yf, {MapSet.new(), nil}, fn row, acc ->
      Enum.reduce(
        x0..xf,
        acc,
        fn col, {blockers, pos} ->
          value = grid |> elem(row) |> elem(col)
          case value do
            "#" -> {MapSet.put(blockers, {row, col}), pos}
            "^" -> {blockers, {row, col}}
            _ -> {blockers, pos}
          end
        end)
    end)

    {grid_bounds, blockers, pos}
  end

  def part1(input) do
    {grid_bounds, blockers, pos} = build_grid_info(input)
    step(:up, %{}, blockers, grid_bounds, pos)
  end
  def part2(input) do
    {grid_bounds, blockers, pos} = build_grid_info(input)
    {y0, x0, yf, xf} = grid_bounds
    Task.async_stream(y0..yf, fn row ->
      Task.async_stream(x0..xf, fn col ->
        if step_is_loop(:up, %{}, MapSet.put(blockers, {row, col}), grid_bounds, pos), do: 1, else: 0
      end)
        |> Stream.map(fn {:ok, val} -> val end)
        |> Enum.sum()
    end)
      |> Stream.map(fn {:ok, val} -> val end)
      |> Enum.sum()
  end
end
