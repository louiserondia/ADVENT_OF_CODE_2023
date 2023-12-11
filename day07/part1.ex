defmodule AoC do
  defp score(l) do
    case l |> Enum.group_by(& &1) |> Map.values() |> Enum.map(&length/1) |> Enum.sort() do
      [5] -> 6
      [1, 4] -> 5
      [2, 3] -> 4
      [1, 1, 3] -> 3
      [1, 2, 2] -> 2
      [1, 1, 1, 2] -> 1
      [1, 1, 1, 1, 1] -> 0
    end
  end

  defp equal(l1, l2) do
    alphabet =
      "23456789TJQKA"
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {k, v}, acc -> acc |> Map.put(k, v) end)

    {v1, v2} = Enum.zip(l1, l2) |> Enum.find(fn {n1, n2} -> alphabet[n1] != alphabet[n2] end)
    alphabet[v1] < alphabet[v2]
  end

  defp less(l1, l2) do
    case {score(l1), score(l2)} do
      {n, n} -> equal(l1, l2)
      {n1, n2} -> n1 < n2
    end
  end

  def solve(file_path) do
    with {:ok, content} <- File.read(file_path) do
      data =
        content
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&String.split(&1))
        |> Enum.map(fn [left, right] -> {left |> String.graphemes(), String.to_integer(right)} end)

      data
      |> Enum.sort(fn {l1, _}, {l2, _} -> less(l1, l2) end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.with_index()
      |> Enum.map(fn {n, i} -> n * (i + 1) end)
			|> Enum.sum()

    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
