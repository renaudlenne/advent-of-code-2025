defmodule AdventOfCode.Solution.Year2025.Day06Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2025.Day06

  setup do
    [
      input: "123 328  51 64 \n 45 64  387 23 \n  6 98  215 314\n*   +   *   +  \n"
    ]
  end

  test "part1", %{input: input} do
    result = part1(input)

    assert result == 4277556
  end

  test "part2", %{input: input} do
    result = part2(input)

    assert result == 3263827
  end
end
