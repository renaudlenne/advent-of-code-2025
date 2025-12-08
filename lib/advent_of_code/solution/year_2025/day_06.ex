defmodule AdventOfCode.Solution.Year2025.Day06 do
  @whitespace_regex ~r{\s+}

  def apply_operator(numbers, "+"), do: Enum.sum(numbers)
  def apply_operator(numbers, "*"), do: Enum.product(numbers)

  def do_col_operation([operator | numbers]) do
    numbers
    |> Enum.map(&String.to_integer/1)
    |> apply_operator(operator)
  end

  def parse_inverse_lines(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reverse()
  end

  def part1(input) do
    input
    |> parse_inverse_lines()
    |> Enum.map(fn line -> String.split(line, @whitespace_regex, trim: true) end)
    |> Enum.zip_reduce(0, fn col, acc ->
      acc + do_col_operation(col)
    end)
  end

  def part2(input) do
    [operators_line | lines ] = input
    |> parse_inverse_lines()

    operations = operators_line
    |> String.split(@whitespace_regex, trim: true)

    lines
    |> Enum.reverse()
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.chunk_while([], fn col, acc ->
      if col |> Enum.all?(fn char -> char == " " end) do
        {:cont, acc, []}
      else
        {:cont, [col |> Enum.join() |> String.trim() |> String.to_integer() | acc]}
      end
    end, fn acc -> {:cont, acc, []} end)
    |> Enum.zip_reduce(operations, 0, fn numbers, operation, acc ->
      acc + apply_operator(numbers, operation)
    end)
  end
end

