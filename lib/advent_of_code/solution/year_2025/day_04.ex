defmodule AdventOfCode.Solution.Year2025.Day04 do
  def remove_rolls(map) do
    size_y = length(map)
    size_x = length(hd(map))

    0..(size_x-1)
    |> Enum.reduce({map, 0}, fn x, acc_x ->
      0..(size_y-1)
      |> Enum.reduce(acc_x, fn y, {new_map, acc} ->
        case AdventOfCode.Utils.char_at(map, {x, y}) do
          "@" ->
            nb_neighboring_rolls = AdventOfCode.Utils.neighbors({x, y})
                                   |> Enum.map(fn coord -> AdventOfCode.Utils.char_at(map, coord) end)
                                   |> Enum.count(fn val -> val == "@" end)

            case nb_neighboring_rolls do
              nb when nb < 4 -> {AdventOfCode.Utils.replace_char_at(new_map, {x, y}, "."), acc + 1}
              _ -> {new_map, acc}
            end


          _ -> {new_map, acc}
        end
      end)
    end)
  end

  def part1(input) do
    map = input
    |> String.trim()
    |> String.split("\n")
    |> AdventOfCode.Utils.parse_map()

    {_, nb_removed_rolls} = remove_rolls(map)

    nb_removed_rolls
  end

  def remove_all_rolls(map, acc) do
    case remove_rolls(map) do
      {_, 0} -> acc
      {new_map, nb_removed} -> remove_all_rolls(new_map, acc + nb_removed)
    end
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> AdventOfCode.Utils.parse_map()
    |> remove_all_rolls(0)
  end
end
