defmodule AdventOfCode.Solution.Year2025.Day05 do

  def is_food_fresh?(_, []), do: false
  def is_food_fresh?(food_id, [{min, max} | _]) when food_id >= min and food_id <= max, do: true
  def is_food_fresh?(food_id, [_ | range]), do: is_food_fresh?(food_id, range)

  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce({[], :parse_range}, fn
      "", {ranges, :parse_range} -> {ranges, 0}
      line, {range_acc, :parse_range} ->
        [min, max] = String.split(line, "-")
        {[{String.to_integer(min), String.to_integer(max)} | range_acc ], :parse_range}
      food_id, {ranges, acc} -> {ranges, acc + (if is_food_fresh?(String.to_integer(food_id), ranges), do: 1, else: 0)}
    end)
    |> then(fn {_, nb_fresh} -> nb_fresh end)
  end

  def count_fresh_ids(ranges, last_counted_max \\ 0, count \\ 0)
  def count_fresh_ids([], _, count), do: count
  def count_fresh_ids([{_, max} | rest], last_counted_max, count) when max <= last_counted_max, do: count_fresh_ids(rest, last_counted_max, count)
  def count_fresh_ids([{min, max} | rest], last_counted_max, count) when min <= last_counted_max, do: count_fresh_ids(rest, max, count + (max - last_counted_max))
  def count_fresh_ids([{min, max} | rest], _, count), do: count_fresh_ids(rest, max, count + (max - min + 1))

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce_while([], fn
      "", ranges -> {:halt, ranges}
      line, acc ->
        [min, max] = String.split(line, "-")
        {:cont, [{String.to_integer(min), String.to_integer(max)} | acc ]}
    end)
    |> Enum.sort_by(fn {min, _} -> min end, :asc)
    |> count_fresh_ids()
  end
end
