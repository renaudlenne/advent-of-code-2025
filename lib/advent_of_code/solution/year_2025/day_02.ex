defmodule AdventOfCode.Solution.Year2025.Day02 do
  def is_invalid_id(id, :part1) do
    id
    |> Integer.to_string()
    |> String.match?(~r/^(\d+)\1$/)
  end
  def is_invalid_id(id, :part2) do
    id
    |> Integer.to_string()
    |> String.match?(~r/^(\d+)\1+$/)
  end

  def count_invalid_ids([], acc, _), do: acc
  def count_invalid_ids([id | rest], acc, part) do
    count_invalid_ids(rest, acc + (if is_invalid_id(id, part), do: id, else: 0), part)
  end

  def parse_and_count_invalid(input, part) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn range -> String.split(range, "-") |> Enum.map(&String.to_integer/1) end)
    |> Enum.reduce(0, fn [range_start, range_end], acc ->
      range_start..range_end
      |> Enum.to_list()
      |> count_invalid_ids(acc, part)
    end)
  end

  def part1(input) do
    input
    |> parse_and_count_invalid(:part1)
  end

  def part2(input) do
    input
    |> parse_and_count_invalid(:part2)
  end
end