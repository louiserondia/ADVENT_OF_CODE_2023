defmodule AoC do
  defp traverse(p, steps, _, acc, cache, _, target) when steps == target do
    {acc |> MapSet.put(p), cache}
  end

  defp traverse({x, y}, steps, data, acc, cache, w, target) do
    if cache |> MapSet.member?({{x, y}, steps}) do
      {acc, cache}
    else
      cache = cache |> MapSet.put({{x, y}, steps})

      [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]
      |> Stream.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Stream.filter(fn {x, y} -> data[{x |> Integer.mod(w), y |> Integer.mod(w)}] == "." end)
      |> Enum.reduce({acc, cache}, fn p, {acc, cache} ->
        traverse(p, steps + 1, data, acc, cache, w, target)
      end)
    end
  end

  defp traverse(p0, data, w, target) do
    traverse(p0, 0, data, MapSet.new(), MapSet.new(), w, target) |> elem(0) |> MapSet.size()
  end

  defp lagrange([{x0, y0}, {x1, y1}, {x2, y2}], x) do
    (x - x1) * (x - x2) / ((x0 - x1) * (x0 - x2)) * y0 +
      (x - x0) * (x - x2) / ((x1 - x0) * (x1 - x2)) * y1 +
      (x - x0) * (x - x1) / ((x2 - x0) * (x2 - x1)) * y2
  end

  def solve(path) do
    with {:ok, content} <- File.read(path) do
      data =
        content
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&String.trim(&1))
        |> Enum.with_index()
        |> Enum.flat_map(fn {s, y} ->
          s
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.map(fn {c, x} -> {{x, y}, c} end)
        end)
        |> Enum.reduce(%{}, fn {k, v}, acc -> acc |> Map.put(k, v) end)

      p0 = data |> Enum.find(fn {_, v} -> v == "S" end) |> elem(0)
      data = data |> Map.replace(p0, ".")
      w = (data |> Map.keys() |> Enum.max() |> elem(0)) + 1
      max = 26_501_365
      start = max |> rem(w)

      [start, start + w, start + w * 2]
      |> Enum.map(fn x ->
        {x, traverse(p0, data, w, x)}
      end)
      |> lagrange(max)
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
