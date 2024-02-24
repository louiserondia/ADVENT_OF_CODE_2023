defmodule AoC do
  defp new_ranges(condition, ranges) do
    [k, n] = condition |> String.split(["<", ">"])
    n = n |> String.to_integer()
    first..last = ranges[k]

    case condition |> String.contains?("<") do
      true -> {ranges |> Map.put(k, first..(n - 1)), ranges |> Map.put(k, n..last)}
      _ -> {ranges |> Map.put(k, (n + 1)..last), ranges |> Map.put(k, first..n)}
    end
  end

  defp traverse([["R"]], _, _), do: 0

  defp traverse([["A"]], _, ranges),
    do: ranges |> Map.values() |> Enum.map(&Range.size(&1)) |> Enum.product()

  defp traverse([[next]], rules, ranges), do: traverse(rules[next], rules, ranges)

  defp traverse([[condition, next] | tail], rules, ranges) do
    {r1, r2} = new_ranges(condition, ranges)

    res =
      if next == "A" or next == "R",
        do: traverse([[next]], rules, r1),
        else: traverse(rules[next], rules, r1)

    res + traverse(tail, rules, r2)
  end

  def solve(file_path) do
    with {:ok, content} <- File.read(file_path) do
      rules =
        content
        |> String.trim()
        |> String.replace("\r", "")
        |> String.split("\n\n")
        |> List.first()
        |> String.split("\n")
        |> Enum.map(&String.split(&1, "{"))
        |> Enum.reduce(%{}, fn [k, v], acc ->
          v = v |> String.trim("}") |> String.split(",") |> Enum.map(&String.split(&1, ":"))
          acc |> Map.put(k, v)
        end)

      ranges = %{"x" => 1..4000, "m" => 1..4000, "a" => 1..4000, "s" => 1..4000}

      traverse(rules["in"], rules, ranges)
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result", limit: :infinity)
