defmodule AdventOfCode.Utils do
  def comb(_, 0), do: [[]]
  def comb([], _), do: []
  def comb([h|t], m) do
    (for l <- comb(t, m-1), do: [h|l]) ++ comb(t, m)
  end

  def parse_map(input, transform \\ fn x -> x end) do
    input
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.graphemes()
      |> Enum.map(&(transform.(&1)))
    end)
  end

  def neighbors({x, y}) do
    [{x-1, y}, {x+1, y}] ++
    (((x-1)..(x+1))
     |> Enum.flat_map(fn new_x -> [{new_x, y-1}, {new_x, y+1}] end))
  end

  def transpose(rows) do
    rows
    |> Enum.zip
    |> Enum.map(&Tuple.to_list/1)
  end

  def char_at(map, coord, default \\ "#")
  def char_at(_, {-1, _}, default), do: default
  def char_at(_, {_, -1}, default), do: default
  def char_at(map, {x, y}, default) do
    max_y = length(map)
    if (y == max_y) do
      default
    else
      max_x = length(hd(map))
      if (x == max_x) do
        default
      else
        Enum.at(map, y) |> Enum.at(x)
      end
    end
  end

  def replace_char_at(map, {x, y}, new_char) do
    List.replace_at(map, y, Enum.at(map, y) |> List.replace_at(x, new_char))
  end

end