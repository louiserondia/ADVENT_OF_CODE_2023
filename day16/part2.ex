defmodule AoC do
  defp traverse({x, y}, {dx, dy}, data, pipes, cache) do
    if cache[{x, y}] == {dx, dy} or is_nil(data[{x, y}]) do
      cache
    else
      cache = cache |> Map.put({x, y}, {dx, dy})
      f = fn {dx, dy}, cache -> traverse({x + dx, y + dy}, {dx, dy}, data, pipes, cache) end

      case pipes[data[{x, y}]][{dx, dy}] do
        nil -> f.({dx, dy}, cache)
        l -> l |> Enum.reduce(cache, fn {dx, dy}, cache -> f.({dx, dy}, cache) end)
      end
    end
  end

  defp compute({x, y}, {dx, dy}, data, pipes) do
    traverse({x, y}, {dx, dy}, data, pipes, %{}) |> map_size()
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

      dirs = %{
        n: {0, -1},
        s: {0, 1},
        w: {-1, 0},
        e: {1, 0}
      }

      pipes = %{
        "|" => %{dirs.e => [dirs.n, dirs.s], dirs.w => [dirs.n, dirs.s]},
        "-" => %{dirs.n => [dirs.w, dirs.e], dirs.s => [dirs.w, dirs.e]},
        "\\" => %{
          dirs.n => [dirs.w],
          dirs.s => [dirs.e],
          dirs.w => [dirs.n],
          dirs.e => [dirs.s]
        },
        "/" => %{
          dirs.n => [dirs.e],
          dirs.s => [dirs.w],
          dirs.w => [dirs.s],
          dirs.e => [dirs.n]
        },
        "." => %{}
      }

      mx = data |> Map.keys() |> Stream.map(&elem(&1, 0)) |> Enum.max()
      my = data |> Map.keys() |> Stream.map(&elem(&1, 1)) |> Enum.max()

      0..my
      |> Stream.flat_map(fn y -> 0..mx |> Enum.map(fn x -> {x, y} end) end)
      |> Stream.filter(fn {x, y} -> x == 0 or x == mx or y == 0 or y == my end)
      |> Stream.map(fn {x, y} ->
        dirs
        |> Map.values()
        |> Stream.map(fn {dx, dy} -> compute({x, y}, {dx, dy}, data, pipes) end)
        |> Enum.max()
      end)
      |> Enum.max()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
