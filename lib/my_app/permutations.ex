defmodule MyApp.Permutations do
  def generate([]), do: [[]]

  def generate(list) do
    for elem <- list, rest <- generate(List.delete(list, elem)) do
      [elem | rest]
    end
  end
end
