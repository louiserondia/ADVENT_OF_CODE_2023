defmodule AoC do
  defp check_condition(condition, data) do
    [k, n] = condition |> String.split(["<", ">"])
    n = n |> String.to_integer()

    case condition |> String.contains?("<") do
      true -> data[k] < n
      _ -> data[k] > n
    end
  end

  defp traverse([["R"]], _, _), do: 0

  defp traverse([["A"]], _, data), do: data |> Map.values() |> Enum.sum()

  defp traverse([[next]], rules, data), do: traverse(rules[next], rules, data)

  defp traverse([[condition, next] | tail], rules, data) do
    case check_condition(condition, data) do
      true ->
        if next == "A" or next == "R",
          do: traverse([[next]], rules, data),
          else: traverse(rules[next], rules, data)

      _ ->
        traverse(tail, rules, data)
    end
  end

  def solve(file_path) do
    with {:ok, content} <- File.read(file_path) do
      [rules, data] =
        content
        |> String.trim()
        |> String.replace("\r", "")
        |> String.split("\n\n")

      rules =
        rules
        |> String.split("\n")
        |> Enum.map(&String.split(&1, "{"))
        |> Enum.reduce(%{}, fn [k, v], acc ->
          v = v |> String.trim("}") |> String.split(",") |> Enum.map(&String.split(&1, ":"))
          acc |> Map.put(k, v)
        end)

      data =
        data
        |> String.split("\n")
        |> Enum.map(&String.replace(&1, ["{", "}"], ""))
        |> Enum.map(&String.split(&1, ","))
        |> Enum.map(fn l ->
          l
          |> Enum.reduce(%{}, fn s, acc ->
            [k, v] = s |> String.split("=")
            acc |> Map.put(k, v |> String.to_integer())
          end)
        end)

      data
      |> Enum.reduce(0, fn d, acc ->
        acc + traverse(rules["in"], rules, d)
      end)
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result", limit: :infinity)
