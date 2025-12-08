defmodule AdventOfCode.Solution.Year2025.Day07 do
  @split_char ?^
  @empty_char ?.

  def split_beam(line, {init_beams, init_count_split}) do
    init_beams
    |> Enum.reduce({[], init_count_split}, fn beam, {beams, count_split} ->
      case :binary.at(line, beam) do
        @split_char -> {[beam-1, beam+1 | beams], count_split + 1}
        @empty_char -> {[beam | beams], count_split}
      end
    end)
    |> then(fn {beams, count_split} -> {MapSet.new(beams), count_split} end)
  end

  def part1(input) do
    [first_line | lines] = input
    |> String.split("\n", trim: true)

    starting_beam = first_line
    |> String.graphemes()
    |> Enum.find_index(fn char -> char == "S" end)

    lines
    |> Enum.reduce({[starting_beam], 0}, &split_beam/2)
    |> then(fn {_, count} -> count end)
  end

  def count_quantic_split(splitters, beam, height, known_beams \\ %{})
  def count_quantic_split(_, {_, y}, height, known_beams) when y > height, do: {1, known_beams}
  def count_quantic_split(splitters, beam, height, known_beams) do
    case Map.get(known_beams, beam) do
      nil ->
        {x, y} = beam

        if MapSet.member?(splitters, beam) do
          {left_count, left_known} = count_quantic_split(splitters, {x-1, y+1}, height, known_beams)
          {right_count, right_known} = count_quantic_split(splitters, {x+1, y+1}, height, left_known)
          {left_count + right_count, Map.put(right_known, beam, left_count + right_count)}
        else
          {new_count, new_known} = count_quantic_split(splitters, {x, y+1}, height, known_beams)
          {new_count, Map.put(new_known, beam, new_count)}
        end
      c ->
        {c, known_beams}
    end
  end

  def part2(input) do
    [first_line | lines] = input
    |> String.split("\n", trim: true)

    starting_beam = first_line
    |> String.graphemes()
    |> Enum.find_index(fn char -> char == "S" end)

    splitters = lines
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _} -> char == "^" end)
      |> Enum.map(fn {_, x} -> {x, y+1} end)
    end)
    |> MapSet.new()

    height = lines |> length()

    {nb_timelines, _} = count_quantic_split(splitters, {starting_beam, 0}, height)
    nb_timelines
  end
end
