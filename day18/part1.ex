defmodule AoC do
  @dirs %{
    "U" => {0, -1},
    "D" => {0, 1},
    "L" => {-1, 0},
    "R" => {1, 0}
  }

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp fill(set, cur) do
    if set |> MapSet.member?(cur) do
      set
    else
      set = set |> MapSet.put(cur)
      @dirs |> Map.values() |> Enum.reduce(set, fn d, acc -> fill(acc, add(cur, d)) end)
    end
  end

  def calc([], _, res), do: res

  def calc([[dir, n] | tail], last, res) do
    {last, res} =
      0..(String.to_integer(n) - 1)
      |> Enum.reduce({last, res}, fn _, {l, acc} ->
        coord = add(l, @dirs[dir])
        {coord, acc |> MapSet.put(coord)}
      end)

    calc(tail, last, res)
  end

  def solve(file_path) do
    with {:ok, content} <- File.read(file_path) do
      data =
        content
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&String.split(&1))
        |> Enum.map(&List.delete_at(&1, -1))

      set = calc(data, {0, 0}, MapSet.new() |> MapSet.put({0, 0}))
      {w, h} = set |> Enum.max()
      start = {Enum.random(0..w), Enum.random(0..h)}

      fill(set, start) |> MapSet.size()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result", limit: :infinity)
