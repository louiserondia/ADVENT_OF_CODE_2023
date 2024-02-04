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

  defp traverse({x, y}, {{dx, dy}, i}, data, cache, {w, h}) do
    # Get the next possible directions,
    # checks if they exist and if we haven't been that way 3 times
    next =
      @dirs
      |> Enum.filter(fn {nx, ny} -> data[{x + nx, y + ny}] end)
      |> Enum.filter(fn dir -> !(dir == {dx, dy} && i == 3) end)
      |> Enum.filter(fn {dirx, diry} -> !(dirx == dx * -1 && diry == dy * -1) end)

    # Updating cache with all scores,
    # if we have a new way to go somewhere cheaper, it's updated
    cache =
      next
      |> Enum.reduce(cache, fn {nx, ny}, acc ->
        new_pos = {x + nx, y + ny}
        score = (acc[{{x, y}, {{dx, dy}, i}}] |> elem(0)) + data[new_pos]
        i = if {nx, ny} == {dx, dy}, do: i + 1, else: 1
        cache_score = acc[{new_pos, {{nx, ny}, i}}]

        double =
          acc |> Enum.find(fn {{c, {d, _}}, _} -> c == new_pos && d == {nx, ny} end)

        if cache_score || (double && double |> elem(0) |> elem(1) |> elem(1) < i) do
          acc
        else
          # if double && double |> elem(0) |> elem(1) |> elem(1) > i do
          #   acc = acc |> Map.delete(double |> elem(0))
          # end

          acc |> Map.put({new_pos, {{nx, ny}, i}}, {score, false})
        end
      end)

    # si on a une valeur a cache[{w, h}, _], on arrête
    if next |> Enum.find(fn {nx, ny} -> {x + nx, y + ny} == {w, h} end) do
      cache
    else
      # Get the next spot to go to, it has to exist and be the lowest score and lowest dir
      {{npos, ndir}, {nscore, _}} =
        cache
        |> Enum.filter(fn {{coord, _}, {_, have_been}} -> data[coord] && have_been == false end)
        # |> Enum.sort_by(fn {{_, {_, i}}, {score, _}} -> {score, i} end)
        |> Enum.min_by(fn {{{x, y}, {_, i}}, {score, _}} -> {score, i, -x, -y} end)
        # |> IO.inspect()

      cache = cache |> Map.put({npos, ndir}, {nscore, true})

      traverse(npos, ndir, data, cache, {w, h})
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

      traverse({0, 0}, {{0, 0}, 0}, data, %{{{0, 0}, {{0, 0}, 0}} => {0, true}}, {w, h})
      # |> Enum.sort_by(fn {{coord, _}, _} -> coord end)
      # |> IO.inspect()
      |> Enum.find(fn {{coord, _}, _} -> coord == {w, h} end)
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "\nResult")

# retirer des possibilités (boucles, i < qui marche)
