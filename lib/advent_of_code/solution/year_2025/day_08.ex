defmodule AdventOfCode.Solution.Year2025.Day08 do

  def distance([[x1, y1, z1], [x2, y2, z2]]) do
    :math.sqrt(:math.pow(x1-x2, 2) + :math.pow(y1-y2, 2) + :math.pow(z1-z2, 2))
  end

  def part1(input, nb_pairs \\ 1000) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
    |> AdventOfCode.Utils.comb(2)
    |> Enum.sort_by(&distance/1, :asc)
    |> Enum.take(nb_pairs)
    |> Enum.reduce([], fn [box1, box2], groups ->
      box1_idx = Enum.find_index(groups, fn g -> Enum.member?(g, box1) end)
      box2_idx = Enum.find_index(groups, fn g -> Enum.member?(g, box2) end)
      cond do
        box1_idx == nil and box2_idx == nil -> [[box1, box2] | groups]
        box1_idx == box2_idx -> groups
        box1_idx == nil -> List.replace_at(groups, box2_idx, [box1 | Enum.at(groups, box2_idx)])
        box2_idx == nil -> List.replace_at(groups, box1_idx, [box2 | Enum.at(groups, box1_idx)])
        true ->
          {smallest_idx, largest_idx} = Enum.min_max([box1_idx, box2_idx])
          List.replace_at(groups, smallest_idx, Enum.at(groups, smallest_idx) ++ Enum.at(groups, largest_idx))
          |> List.delete_at(largest_idx)
      end
    end)
    |> Enum.sort_by(&length/1, :desc)
    |> Enum.take(3)
    |> Enum.map(&length/1)
    |> Enum.product()
  end

  def part2(input) do
    boxes = input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)

    initial_groups = boxes
    |> Enum.map(fn box -> [box] end)

    boxes
    |> AdventOfCode.Utils.comb(2)
    |> Enum.sort_by(&distance/1, :asc)
    |> Enum.reduce_while(initial_groups, fn [box1, box2], groups ->
      box1_idx = Enum.find_index(groups, fn g -> Enum.member?(g, box1) end)
      box2_idx = Enum.find_index(groups, fn g -> Enum.member?(g, box2) end)
      if box1_idx == box2_idx do
        {:cont, groups}
      else
        {smallest_idx, largest_idx} = Enum.min_max([box1_idx, box2_idx])

        new_groups = List.replace_at(groups, smallest_idx, Enum.at(groups, smallest_idx) ++ Enum.at(groups, largest_idx))
        |> List.delete_at(largest_idx)

        case new_groups do
          [_] -> {:halt, hd(box1) * hd(box2)}
          _ -> {:cont, new_groups}
        end
      end
    end)
  end
end
