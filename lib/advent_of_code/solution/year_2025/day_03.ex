defmodule AdventOfCode.Solution.Year2025.Day03 do

  def largest_joltage(batteries, nb_left, acc \\ [])

  def largest_joltage(batteries, 1, acc) do
    next_char = Enum.max(batteries)
    [next_char | acc]
    |> Enum.reverse()
    |> Enum.join("")
    |> String.to_integer()
  end

  def largest_joltage(batteries, nb_left, acc) do
    start = batteries |> Enum.reverse() |> Enum.drop(nb_left-1)
    next_char = Enum.max(start)
    [ _ | next_part ] = batteries |> Enum.drop_while(fn char -> char != next_char end)
    largest_joltage(next_part, nb_left-1, [next_char | acc])
  end

  def parse_and_solve(input, joltage_size) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(0, fn line, acc -> acc + largest_joltage(String.graphemes(line), joltage_size) end)
  end

  def part1(input), do: parse_and_solve(input, 2)

  def part2(input), do: parse_and_solve(input, 12)
end
