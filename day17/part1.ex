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

  defp traverse({x, y}, {dx, dy}, dirs, data, cache, {w, h}) do

    next = # Get the next possible directions, checks if they exist and if we haven't been that way 3 times
      dirs
      |> Enum.filter(fn {x1, y1} -> data[{x + x1, y + y1}] end)
      |> Enum.filter(fn dir -> not (dir == {dx, dy} && (abs(dx) == 3 || abs(dy) == 3)) end)
      # |> Enum.map(fn {x1, y1} -> {x + x1, y + y1} end)

    cache = # Updating cache with all scores, if we have a new way to go somewhere cheaper, it's updated in the cache
      next
      |> Enum.reduce(cache, fn {nx, ny}, acc ->
        new_pos = {x + nx, y + ny}
        new_score = cache[{{x, y}, {dx, xy}}] + data[new_pos]
        next_dir = case {nx, ny} do
          {0, ^dy} -> {0, (abs(dy) + 1) * y} #2e fois la même en verticale
          {^dx, 0} -> {(abs(dx) + 1) * x, 0}
          {^dx, y} when y < abs(dy) -> {0, (abs(dy) + 1) * y} #3e fois
          {x, ^dy} when x < abs(dx) -> {(abs(dx) + 1) * x, 0}
          {x, y} -> {x, y} # 1e fois, quand nx et ny sont != de dx, dy
        end

        if is_nil(acc[new_pos]) || new_score < acc[new_pos] |> elem(0) do
          acc |> Map.put({new_pos, next_dir}, new_score)
        else
          acc
        end
      end)

    if  do #si on a une valeur a cache[{w, h}, _] utiliser find ?
      cache
    else
      {npos, ndir} = # Get the next spot to go to, it has to exist and be the lowest score and lowest dir ??
        cache
        |> Enum.filter(fn {{coord, _}, _} -> data[coord] end)
        |> Enum.min_by(fn {_, v} -> v end)
        |> elem(0)

      traverse(npos, ndir, dirs, data, cache, {w, h})
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

      # r =
         traverse({0, 0}, {0, 0}, dirs, data, %{{{0, 0}, nil} => 0}, {w, h})
      # print({w, h}, r)
      # r[{w, h}] |> elem(0)

    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
