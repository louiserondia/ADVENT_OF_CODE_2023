defmodule AoC do
  defp calc([]), do: 0

  defp calc([{x, y} | tail]) do
    res =
      Enum.map(tail, fn {tx, ty} ->
        abs(tx - x) + abs(ty - y)
      end)
      |> Enum.sum()

    res + calc(tail)
  end

  def solve(file_path) do
    with {:ok, content} <- File.read(file_path) do
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
          |> Enum.filter(fn {c, _} -> c != "." end)
          |> Enum.map(fn {_, x} -> {x, y} end)
        end)

      missing_x =
        0..(Enum.max_by(data, &elem(&1, 0)) |> elem(0))
        |> Enum.filter(fn n ->
          not Enum.any?(data, fn {x, _} -> n == x end)
        end)

      missing_y =
        0..(Enum.max_by(data, &elem(&1, 1)) |> elem(1))
        |> Enum.filter(fn n ->
          not Enum.any?(data, fn {_, y} -> n == y end)
        end)

      Enum.reduce(data, [], fn {x, y}, acc ->
        acc ++
          [
            {x + Enum.count(missing_x, &(&1 < x)) * 999_999,
             y + Enum.count(missing_y, &(&1 < y)) * 999_999}
          ]
      end)
      |> calc()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
