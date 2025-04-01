defmodule MyApp.PermutationsTest do
  use ExUnit.Case, async: true
  alias MyApp.Permutations

  test "generate/1 with empty list returns list with empty list" do
    assert Permutations.generate([]) == [[]]
  end

  test "generate/1 with single element returns list with single element" do
    assert Permutations.generate([1]) == [[1]]
  end

  test "generate/1 with two elements returns all permutations" do
    result = Permutations.generate([1, 2])
    expected = [[1, 2], [2, 1]]

    assert length(result) == 2
    assert Enum.sort(result) == Enum.sort(expected)
  end

  test "generate/1 with three elements returns all permutations" do
    result = Permutations.generate([1, 2, 3])

    expected = [
      [1, 2, 3],
      [1, 3, 2],
      [2, 1, 3],
      [2, 3, 1],
      [3, 1, 2],
      [3, 2, 1]
    ]

    assert length(result) == 6
    assert Enum.sort(result) == Enum.sort(expected)
  end

  test "generate/1 with duplicate elements returns all permutations" do
    result = Permutations.generate([1, 1, 2])

    expected = [
      [1, 1, 2],
      [1, 2, 1],
      [2, 1, 1],
      [1, 1, 2],
      [1, 2, 1],
      [2, 1, 1]
    ]

    assert length(result) == 6
    assert Enum.sort(result) == Enum.sort(expected)
  end

  test "generate/1 with atoms returns correct permutations" do
    result = Permutations.generate([:a, :b])
    expected = [[:a, :b], [:b, :a]]

    assert length(result) == 2
    assert Enum.sort(result) == Enum.sort(expected)
  end

  test "generate/1 with mixed types returns correct permutations" do
    result = Permutations.generate([1, :a, "b"])
    assert length(result) == 6
    assert [1, :a, "b"] in result
    assert [:a, 1, "b"] in result
    assert ["b", :a, 1] in result
  end
end
