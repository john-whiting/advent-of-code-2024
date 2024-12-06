defmodule Day06 do
  @next_direction %{:up => :right, :down => :left, :left => :up, :right => :down}

  def bounds(grid) when is_tuple(grid) do
    {0, 0, tuple_size(grid) - 1, tuple_size(elem(grid, 0)) - 1}
  end

  def next_pos(:up, {y, x}), do: {y - 1, x}
  def next_pos(:down, {y, x}), do: {y + 1, x}
  def next_pos(:left, {y, x}), do: {y, x - 1}
  def next_pos(:right, {y, x}), do: {y, x + 1}

  defguard is_edge(grid_bounds, pos) when
    elem(grid_bounds, 0) == elem(pos, 0) or
    elem(grid_bounds, 2) == elem(pos, 0) or
    elem(grid_bounds, 1) == elem(pos, 1) or
    elem(grid_bounds, 3) == elem(pos, 1)

  def step(direction, blockers, grid_bounds, pos, visits \\ MapSet.new())
  def step(_, _, grid_bounds, pos, visits) when is_edge(grid_bounds, pos), do: MapSet.put(visits, pos)
  def step(direction, blockers, grid_bounds, pos, visits) when is_atom(direction) do
    next = next_pos(direction, pos)
    if MapSet.member?(blockers, next) do
      step(@next_direction[direction], blockers, grid_bounds, pos, visits)
    else
      step(direction, blockers, grid_bounds, next, MapSet.put(visits, pos))
    end
  end

  def is_loop?(direction, blockers, grid_bounds, pos, visits \\ %{})
  def is_loop?(_, _, grid_bounds, pos, _) when is_edge(grid_bounds, pos), do: false
  def is_loop?(direction, blockers, grid_bounds, pos, visits) when is_atom(direction) do
    next = next_pos(direction, pos)
    directions_visited = Map.get(visits, pos, MapSet.new())

    if MapSet.member?(directions_visited, direction) do
      true
    else
      new_visits = Map.put(visits, pos, MapSet.put(directions_visited, direction))
      if MapSet.member?(blockers, next) do
        is_loop?(@next_direction[direction], blockers, grid_bounds, pos, new_visits)
      else
        is_loop?(direction, blockers, grid_bounds, next, new_visits)
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
    step(:up, blockers, grid_bounds, pos) |> MapSet.size
  end
  def part2(input) do
    {grid_bounds, blockers, pos} = build_grid_info(input)
    path = step(:up, blockers, grid_bounds, pos)
    Task.async_stream(path, &(if is_loop?(:up, MapSet.put(blockers, &1), grid_bounds, pos), do: 1, else: 0))
      |> Stream.map(fn {:ok, val} -> val end)
      |> Enum.sum()
  end
end
