defmodule AoC do
  defp check_line(l, distrib) do
    l = l |> String.graphemes()
    n = l |> Enum.count(&(&1 == "#"))

    res =
      Enum.reduce(l, {".", [], 0}, fn c, {prev, acc, n} ->
        case {prev, c} do
          {_, "#"} -> {c, acc, n + 1}
          {"#", _} -> {c, acc ++ [n], 0}
          _ -> {c, acc, n}
        end
      end)

    res = (elem(res, 1) ++ [elem(res, 2)]) |> Enum.filter(&(&1 != 0))

    cond do
      n != distrib |> Enum.sum() -> [""]
      res != distrib -> [""]
      true -> [l |> Enum.join()]
    end
  end

  defp generate(s, i, n) do
    if i == String.length(s) do
      check_line(s, n)
    else
      c = String.at(s, i)

      case c do
        "?" ->
          generate(String.replace(s, "?", "#", global: false), i + 1, n) ++
            generate(String.replace(s, "?", ".", global: false), i + 1, n)

        _ ->
          generate(s, i + 1, n)
      end
    end
  end

  def solve(file_path) do
    with {:ok, content} <- File.read(file_path) do
      content
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.split(&1))
      |> Enum.map(fn [s, n] -> [s, String.split(n, ",") |> Enum.map(&String.to_integer(&1))] end)
      |> Enum.map(fn [s, n] ->
        generate(s, 0, n) |> Enum.filter(&(&1 != "")) |> Enum.count()
      end)

      |> Enum.sum()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
