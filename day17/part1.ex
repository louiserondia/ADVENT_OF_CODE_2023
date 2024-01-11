defmodule AoC do
  defp map2d(s) do
    s
    |> Enum.with_index()
    |> Enum.flat_map(fn {v, y} ->
      v
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {v, x} -> {{x, y}, v} end)
    end)
    |> Enum.reduce(%{}, fn {k, v}, acc -> acc |> Map.put(k, v) end)
  end

  defp print(pos, cache) do
    IO.inspect(pos)
    n = cache[pos] |> elem(1)
    if n, do: print(n, cache)
  end

  defp count({x, y}, dir, i, cache) do
    prev = cache[{x, y}] |> elem(1)

    case {dir, prev} do
      {{0, 0}, {^x, py}} -> count(prev, {0, y - py}, 1, cache)
      {{0, 0}, {px, ^y}} -> count(prev, {x - px, 0}, 1, cache)
      {{0, _}, {^x, _}} -> count(prev, dir, i + 1, cache)
      {{_, 0}, {_, ^y}} -> count(prev, dir, i + 1, cache)
      _ -> {dir, i}
    end
  end

  defp traverse({x, y}, dirs, data, cache, {w, h}) do
    {pdir, i} = count({x, y}, {0, 0}, 0, cache)

    next =
      dirs
      |> Enum.filter(fn {x1, y1} -> data[{x + x1, y + y1}] end)
      |> Enum.filter(fn dir -> dir != pdir || i != 3 end)
      |> Enum.map(fn {x1, y1} -> {x + x1, y + y1} end)

    data = data |> Map.delete({x, y})
    cur_dist = cache[{x, y}] |> elem(0)

    cache =
      next
      |> Enum.reduce(cache, fn n, acc ->
        next_dist = cur_dist + data[n]

        if is_nil(acc[n]) || next_dist < acc[n] |> elem(0) do
          acc |> Map.put(n, {next_dist, {x, y}})
        else
          acc
        end
      end)

    if Enum.empty?(data) do
      cache
    else
      next_dir =
        cache
        |> Enum.filter(fn {k, _} -> data[k] end)
        |> Enum.min_by(fn {_, {v, _}} -> v end)
        |> elem(0)

      traverse(next_dir, dirs, data, cache, {w, h})
    end
  end

  def solve(path) do
    with {:ok, content} <- File.read(path) do
      data =
        content
        |> String.trim()
        |> String.replace("\r", "")
        |> String.split("\n", trim: true)
        |> map2d()

      {w, h} =
        data
        |> Enum.reduce({0, 0}, fn {{x, y}, _}, {w, h} ->
          {if(x > w, do: x, else: w), if(y > h, do: y, else: h)}
        end)

      dirs = [
        {0, -1},
        {0, 1},
        {-1, 0},
        {1, 0}
      ]

      r = traverse({0, 0}, dirs, data, %{{0, 0} => {0, nil}}, {w, h})
      print({w, h}, r)
      r[{w, h}] |> elem(0)

    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
