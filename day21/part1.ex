defmodule AoC do
  defp traverse(p, 64, _, acc, cache), do: {acc |> MapSet.put(p), cache}

  defp traverse({x, y}, steps, data, acc, cache) do
    if cache |> MapSet.member?({{x, y}, steps}) do
      {acc, cache}
    else
      cache = cache |> MapSet.put({{x, y}, steps})

      [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]
      |> Stream.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Stream.filter(fn p -> data[p] == "." end)
      |> Enum.reduce({acc, cache}, fn p, {acc, cache} ->
        traverse(p, steps + 1, data, acc, cache)
      end)
    end
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
      traverse(p0, 0, data, MapSet.new(), MapSet.new()) |> elem(0) |> MapSet.size()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
