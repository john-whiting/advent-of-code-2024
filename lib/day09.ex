defmodule AdventOfCode2024.Day09 do
  defmodule DiskMap do
    defstruct [map: [], free_spaces: [], unprocessed_spaces: []]

    def swap_in_map(disk_map = %DiskMap{map: map}, range1, range2) do
      Map.replace!(
        disk_map,
        :map,
        Enum.zip(range1, range2 |> Enum.reverse())
          |> Enum.reduce(map, fn {idx0, idx1}, map ->
            put_elem(map, idx0, elem(map, idx1)) |> put_elem(idx1, elem(map, idx0))
          end)
      )
    end

    def compress_no_frag(disk_map = %DiskMap{free_spaces: []}), do: disk_map
    def compress_no_frag(disk_map = %DiskMap{unprocessed_spaces: []}), do: disk_map
    def compress_no_frag(disk_map = %DiskMap{free_spaces: free_spaces, unprocessed_spaces: [{ unprocessed_idx, unprocessed_size } | unprocessed]}) do
      result = Stream.with_index(free_spaces)
        |> Enum.find_value(nil, fn value = {{_, free_size}, _} -> if free_size >= unprocessed_size, do: value end)
      case result do
        nil -> disk_map
        {{free_idx, _}, _} when free_idx > unprocessed_idx -> disk_map
        {{free_idx, free_size}, item_idx} ->
          swap_in_map(disk_map, free_idx..(free_idx + unprocessed_size - 1), unprocessed_idx..(unprocessed_idx + unprocessed_size - 1))
            |> Map.replace!(
                :free_spaces,
                (if free_size == unprocessed_size, do: List.delete_at(free_spaces, item_idx), else: List.replace_at(free_spaces, item_idx, {free_idx + unprocessed_size, free_size - unprocessed_size}))
              )
      end
        |> Map.replace!(:unprocessed_spaces, unprocessed)
        |> compress_no_frag
    end

    def compress(disk_map = %DiskMap{free_spaces: []}), do: disk_map
    def compress(disk_map = %DiskMap{unprocessed_spaces: []}), do: disk_map
    def compress(disk_map = %DiskMap{free_spaces: [free_head | free], unprocessed_spaces: [unprocessed_head | unprocessed]}) do
      {free_idx, free_size} = free_head
      {unprocessed_idx, unprocessed_size} = unprocessed_head
      cond do
        free_idx >= unprocessed_idx ->
          disk_map
            |> Map.replace!(:unprocessed_spaces, unprocessed)
            |> Map.replace!(:free_spaces, free)
        free_size > unprocessed_size ->
          swap_in_map(disk_map, free_idx..(free_idx + unprocessed_size - 1), unprocessed_idx..(unprocessed_idx + unprocessed_size - 1))
            |> Map.replace!(:free_spaces, [{free_idx + unprocessed_size, free_size - unprocessed_size} | free])
            |> Map.replace!(:unprocessed_spaces, unprocessed)
        unprocessed_size > free_size ->
          swap_in_map(disk_map, free_idx..(free_idx + free_size - 1), (unprocessed_idx + unprocessed_size - free_size)..(unprocessed_idx + unprocessed_size - 1))
            |> Map.replace!(:unprocessed_spaces, [{unprocessed_idx, unprocessed_size - free_size} | unprocessed])
            |> Map.replace!(:free_spaces, free)
        true ->
          swap_in_map(disk_map, free_idx..(free_idx + free_size - 1), unprocessed_idx..(unprocessed_idx + free_size - 1))
            |> Map.replace!(:unprocessed_spaces, unprocessed)
            |> Map.replace!(:free_spaces, free)
      end |> compress
    end

    defp add_block(disk_map, file_size, _) when file_size < 1, do: disk_map
    defp add_block(disk_map = %DiskMap{ map: map }, file_size, num) do
      Map.replace!(disk_map, :map, Enum.reduce(0..(file_size - 1), map, fn _, map -> [num | map] end))
    end

    defp mark_free_space(disk_map, _, size) when size < 1, do: disk_map
    defp mark_free_space(disk_map = %DiskMap{free_spaces: free_spaces}, idx, size) do
      Map.replace!(disk_map, :free_spaces, [{idx, size} | free_spaces])
    end

    defp mark_unprocessed_space(disk_map, _, size) when size < 1, do: disk_map
    defp mark_unprocessed_space(disk_map = %DiskMap{unprocessed_spaces: unprocessed_spaces}, idx, size) do
      Map.replace!(disk_map, :unprocessed_spaces, [{idx, size} | unprocessed_spaces])
    end

    defp build_map(disk_map, remaining_string, idx \\ 0, file_id \\ 0, type \\ :file)
    defp build_map(disk_map, "", _, _, _), do: disk_map
    defp build_map(disk_map, <<file_size::binary-size(1), rest::binary>>, idx, file_id, :file) do
      file_size = String.to_integer(file_size)
      add_block(disk_map, file_size, file_id)
        |> mark_unprocessed_space(idx, file_size)
        |> build_map(rest, idx + file_size, file_id + 1, :free)
    end
    defp build_map(disk_map, <<file_size::binary-size(1), rest::binary>>, idx, file_id, :free) do
      file_size = String.to_integer(file_size)
      add_block(disk_map, file_size, ".")
        |> mark_free_space(idx, file_size)
        |> build_map(rest, idx + file_size, file_id, :file)
    end

    def from_input(input) when is_binary(input) do
      %DiskMap{map: map, free_spaces: free, unprocessed_spaces: unprocessed} = build_map(%DiskMap{}, String.trim(input))
      %DiskMap{map: Enum.reverse(map) |> List.to_tuple(), free_spaces: Enum.reverse(free), unprocessed_spaces: unprocessed}
    end
  end

  alias AdventOfCode2024.Day09.DiskMap, as: DiskMap

  def part1(input) when is_binary(input) do
    DiskMap.from_input(input)
      |> DiskMap.compress()
      |> Map.get(:map)
      |> Tuple.to_list()
      |> Stream.with_index()
      |> Stream.map(fn {value, idx} -> if is_integer(value), do: value * idx, else: 0 end)
      |> Enum.sum
  end
  def part2(input) when is_binary(input) do
    DiskMap.from_input(input)
      |> DiskMap.compress_no_frag()
      |> Map.get(:map)
      |> Tuple.to_list()
      |> Stream.with_index()
      |> Stream.map(fn {value, idx} -> if is_integer(value), do: value * idx, else: 0 end)
      |> Enum.sum
  end
end
