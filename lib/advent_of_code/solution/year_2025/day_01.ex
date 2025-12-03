defmodule AdventOfCode.Solution.Year2025.Day01 do
  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.reduce({50, 0}, fn
      "L" <> num, {state, nb_zeros} ->
        new_state = rem(state+100-String.to_integer(num), 100)
        {new_state, (if new_state == 0, do: nb_zeros + 1, else: nb_zeros)}
      "R" <> num, {state, nb_zeros} ->
        new_state = rem(state+String.to_integer(num), 100)
        {new_state, (if new_state == 0, do: nb_zeros + 1, else: nb_zeros)}
      _, acc -> acc
    end)
    |> then(fn {_, nb_zeros} -> nb_zeros end)
  end

  def turn({state, nb_zeros}, num, dir) when num > 100, do: turn({state, nb_zeros+1}, num-100, dir)

  def turn({state, nb_zeros}, num, :left) when num < state, do: {state-num, nb_zeros}
  def turn({state, nb_zeros}, num, :right) when state + num < 100, do: {state+num, nb_zeros}

  def turn({0, nb_zeros}, num, :left), do: turn({99, nb_zeros}, num-1, :left)

  def turn({state, nb_zeros}, num, :left), do: {rem(state+100-num, 100), nb_zeros+1}
  def turn({state, nb_zeros}, num, :right), do: {rem(state+num, 100), nb_zeros+1}

  def part2(input) do
    input
    |> String.split("\n")
    |> Enum.reduce({50, 0}, fn
      "L" <> num, acc -> turn(acc, String.to_integer(num), :left)
      "R" <> num, acc -> turn(acc, String.to_integer(num), :right)
      _, acc -> acc
    end)
    |> then(fn {_, nb_zeros} -> nb_zeros end)
  end
end
