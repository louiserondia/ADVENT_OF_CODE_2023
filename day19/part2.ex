defmodule AoC do
  defp new_ranges(condition, ranges) do
    [k, n] = condition |> String.split(["<", ">"])
    n = n |> String.to_integer()

    first..last = ranges[k]

    op = if condition |> String.contains?("<"), do: "<", else: ">"

    cond do
      (n < first && op == "<") || (n > last && op == ">") ->
        nil

      (n < first && op == ">") || (n > last && op == "<") ->
        ranges |> IO.inspect(label: "yo")

      op == "<" ->
        {ranges |> Map.put(k, first..(n - 1)), ranges |> Map.put(k, n..last)}

      true ->
        {ranges |> Map.put(k, (n + 1)..last), ranges |> Map.put(k, first..n)}
    end
  end

  defp traverse([["R"]], _, _), do: 0

  defp traverse([["A"]], _, ranges),
    do: ranges |> Map.values() |> Enum.map(&Range.size(&1)) |> Enum.product()

  defp traverse([[next]], rules, ranges), do: traverse(rules[next], rules, ranges)

  defp traverse([[condition, next] | tail], rules, ranges) do
    case new_ranges(condition, ranges) do
      nil ->
        traverse(tail, rules, ranges)

      ^ranges ->
        if next == "A" or next == "R",
          do: traverse([[next]], rules, ranges),
          else: traverse(rules[next], rules, ranges)

      {r1, r2} ->
        sum =
          if next == "A" or next == "R",
            do: traverse([[next]], rules, r1),
            else: traverse(rules[next], rules, r1)

        sum + traverse(tail, rules, r2)
    end
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
      # 0..10 |> Range.size()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result", limit: :infinity)
