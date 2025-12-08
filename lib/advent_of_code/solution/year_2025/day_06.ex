defmodule AdventOfCode.Solution.Year2025.Day06 do

  def do_col_operation(["+" | rest]) do
    rest
    |> Enum.reduce(0, fn str, acc -> acc + String.to_integer(str) end)
  end

  def do_col_operation(["*" | rest]) do
    rest
    |> Enum.reduce(1, fn str, acc -> acc * String.to_integer(str) end)
  end

  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, ~r{\s+}, trim: true) end)
    |> Enum.reverse()
    |> Enum.drop(1)
    |> Enum.zip_reduce(0, fn col, acc ->
      acc + do_col_operation(col)
    end)
  end

  def do_col_operation("+", numbers) do
    numbers
    |> Enum.reduce(0, fn num, acc -> acc + num end)
  end

  def do_col_operation("*", numbers) do
    numbers
    |> Enum.reduce(1, fn num, acc -> acc * num end)
  end

  def part2(input) do
    base = input
    |> String.split("\n")
    |> Enum.reverse()
    |> Enum.drop(1)

    operations = base
    |> hd()
    |> String.split(~r{\s+}, trim: true)

    base
    |> Enum.drop(1)
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
      acc + do_col_operation(operation, numbers)
    end)
  end
end
