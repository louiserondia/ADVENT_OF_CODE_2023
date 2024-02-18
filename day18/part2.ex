defmodule AoC do
  @dirs %{
    0 => {1, 0},
    1 => {0, 1},
    2 => {-1, 0},
    3 => {0, -1}
  }

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}
  defp mult(n, {x, y}), do: {x * n, y * n}

  defp shoelace([{_, _} | []], x, y), do: {x, y}

  defp shoelace([{x1, y1} | [{x2, y2} | tail]], x, y) do
    x = x + (x1 * y2)
    y = y + (y1 * x2)
    shoelace([{x2, y2} | tail], x, y)
  end


  def calc([], _, res), do: res

  def calc([{n, dir} | tail], last, res) do
    coord = add(last, mult(n, @dirs[dir]))
    {last, res} =
      {coord, res ++ [coord]}

    calc(tail, last, res)
  end

  def solve(file_path) do
    with {:ok, content} <- File.read(file_path) do
      data =
        content
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&String.split(&1, "#"))
        |> Enum.map(&List.last/1)
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.replace(&1, ")", ""))
        |> Enum.map(fn s -> s |> String.split_at(-1) end)
        |> Enum.map(fn {h, d} -> {h |> String.to_integer(16), d |> String.to_integer()} end)

      summits = data |> Enum.reduce(0, fn {n, _}, acc -> acc + n end)
      set = calc(data, {0, 0}, [{0, 0}])
      {x, y} = shoelace(set, 0, 0)
      shoe = abs(x - y) / 2

      pick = (summits / (-2)) + shoe + 1
      pick + summits
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result", limit: :infinity)
