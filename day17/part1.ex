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

  defp calc({x, y}, prev, count, res, dirs, data, cache) do
    verif = Agent.get(:res, fn r -> r[{{x, y}, elem(count, 0)}] end) #soit rien, soit elem(count, 0), soit count

    if !verif || res <= verif do
      Agent.update(:res, fn r -> r |> Map.put({{x, y}, elem(count, 0)}, res) end)

      cache = cache |> MapSet.put({x, y})

      dirs
      |> Enum.filter(fn {nx, ny} ->
        data[{x + nx, y + ny}] && not (cache |> MapSet.member?({x + nx, y + ny})) &&
          {x + nx, y + ny} != prev
      end)
      |> Enum.map(fn n ->
        ncoord = {x + elem(n, 0), y + elem(n, 1)}

        case count do
          {^n, 3} -> nil
          {^n, i} -> calc(ncoord, {x, y}, {n, i + 1}, res + data[ncoord], dirs, data, cache)
          _ -> calc(ncoord, {x, y}, {n, 1}, res + data[ncoord], dirs, data, cache)
        end
      end)
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

      [w, h] =
        data
        |> Enum.reduce([0, 0], fn {{x, y}, _}, [w, h] ->
          [(if x > w, do: x, else: w), (if y > h, do: y, else: h)]
        end)

        dirs = [
        {0, -1},
        {0, 1},
        {-1, 0},
        {1, 0}
      ]

      Agent.start_link(fn -> %{} end, name: :res)

      calc({0, 0}, {0, 0}, {{0, 0}, 0}, 0, dirs, data, MapSet.new())

      Agent.get(:res, & &1)
      |> Enum.filter(fn {{coord, _}, _} -> coord == {w, h} end)
      |> Enum.sort(:desc)
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.min()


    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
