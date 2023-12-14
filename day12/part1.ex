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
      n != distrib |> Enum.sum() ->
        [""]

      res != distrib ->
        [""]

      true ->
        [l |> Enum.join()]
    end
  end

  defp calc(s, n, hs, pos, prev) do
    p = Enum.at(hs, pos)

    res =
      s
      |> String.graphemes()
      |> Enum.reduce({0, ""}, fn
        c, {i, acc} ->
          case {i, c} do
            {^p, "."} -> {i + 1, acc <> "#"}
            {^p, "#"} -> {i + 1, acc <> "."}
            {_, "?"} -> {i + 1, acc <> "#"}
            {_, a} -> {i + 1, acc <> a}
          end
      end)
      |> elem(1)

    cond do
      prev >= -1 ->
        if pos < length(hs) - 1 do
          check_line(res, n) ++ calc(res, n, hs, pos + 1, prev)
        else
          check_line(res, n) ++ calc(res, n, hs, prev - 1, prev - 1)
        end

      true ->
        check_line(res, n)
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
        hs =
          Enum.with_index(String.graphemes(s))
          |> Enum.filter(fn {c, _} -> c == "?" end)
          |> Enum.map(fn {_, i} -> i end)

        calc(s, n, hs, length(hs), length(hs))
        |> Enum.filter(&(&1 != ""))
        |> Enum.uniq()
        |> Enum.count()
      end)
      |> Enum.sum()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
