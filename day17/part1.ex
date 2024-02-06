defmodule Heap do
  def push(heap, number) do
    heap = heap |> Map.put(map_size(heap), number)
    push_fix(heap, number, map_size(heap) - 1)
  end

  defp push_fix(heap, number, i) do
    pi = div(i - 1, 2)
    parent = heap[pi]

    if parent && number < parent do
      heap = heap |> Map.put(pi, number) |> Map.put(i, parent)
      push_fix(heap, number, pi)
    else
      heap
    end
  end

  def pop(heap) do
    heap = heap |> Map.put(0, heap[map_size(heap) - 1]) |> Map.delete(map_size(heap) - 1)
    pop_fix(heap, heap[0], 0)
  end

  defp pop_fix(heap, number, i) do
    l = heap[i * 2 + 1]
    r = heap[i * 2 + 2]

    if (l && number > l) || (r && number > r) do
      {next, ni} =
        cond do
          (l && r && l > r) || (!l && r) -> {r, i * 2 + 2}
          true -> {l, i * 2 + 1}
        end

      heap = heap |> Map.put(ni, number) |> Map.put(i, next)
      pop_fix(heap, number, ni)
    else
      heap
    end
  end
end

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

  @dirs [
    {0, -1},
    {0, 1},
    {-1, 0},
    {1, 0}
  ]

  defp traverse({score, {x, y}, {{dx, dy}, i}}, cache, data, {w, h}) do
    next =
      @dirs
      |> Enum.filter(fn {nx, ny} -> data[{x + nx, y + ny}] end)
      |> Enum.filter(fn dir -> !(dir == {dx, dy} && i == 3) end)
      |> Enum.filter(fn {dirx, diry} -> !(dirx == dx * -1 && diry == dy * -1) end)

    cache =
      next
      |> Enum.reduce(cache, fn {nx, ny}, acc ->
        new_pos = {x + nx, y + ny}
        new_score = score + data[new_pos]
        i = if {nx, ny} == {dx, dy}, do: i + 1, else: 1

        if acc |> Enum.find(fn {_, {_, c, d}} -> c == {x, y} && d == {{dx, dy}, i} end) do
          acc
        else
          acc |> Heap.push({new_score, new_pos, {{nx, ny}, i}})
        end
      end)

    if next |> Enum.find(fn {nx, ny} -> {x + nx, y + ny} == {w, h} end) do
      cache
    else
      cache = cache |> Heap.pop()
      traverse(cache[0], cache, data, {w, h})
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

      start = %{} |> Heap.push({0, {0, 0}, {{0, 0}, 0}})

      traverse(start[0], start, data, {w, h})
      |> Enum.find(fn {_, {_, coord, _}} -> coord == {w, h} end)
      |> elem(1)
      |> elem(0)
    end
  end
end

AoC.solve("input.txt")
|> IO.inspect(label: "\nResult")
