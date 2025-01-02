defmodule AoC do

  defp coord_range([[sx, sy, sz], [ex, ey, ez]]) do
    for x <- sx..ex, y <- sy..ey, z <- sz..ez, do: {x, y, z}
  end

  defp is_under({x, y, z}, {bx, by, bz}, block) do
    if x == bx and y == by and z < bz and {x, y, z} not in block, do: bz - z, else: 0
  end

  defp check(block, all, acc) do
    under =
      block
      |> Enum.flat_map(fn brick ->
      Enum.filter(all, fn b -> Enum.any?(b, &is_under(&1, brick, block) == 1) end)
    end)
    |> MapSet.new()
    if MapSet.size(under) == 1, do: MapSet.put(acc, Enum.at(under, 0)), else: acc
  end

  defp fall(block, all) do
    under =
      all
      |> Enum.concat()
      |> Enum.filter(fn b ->
        block
        |> Enum.any?(fn brick -> is_under(b, brick, block) > 0 end)
      end)
      |> Enum.max_by(fn {_, _, z} -> z end, fn -> {0, 0, 0} end)
      |> elem(2)

    low_z = elem(Enum.min_by(block, fn {_, _, z} -> z end), 2)
    nb = Enum.map(block, fn {bx, by, bz} -> {bx, by, bz - (low_z - under - 1)} end)
    List.delete(all, block) ++ [nb]
  end

  def solve(path) do
    with {:ok, content} <- File.read(path) do
      data =
        content
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&String.trim(&1))
        |> Enum.flat_map(&String.split(&1, "~"))
        |> Enum.flat_map(&String.split(&1, ","))
        |> Enum.map(&String.to_integer(&1))
        |> Enum.chunk_every(3)
        |> Enum.chunk_every(2)
        |> Enum.map(&coord_range(&1))
        |> Enum.sort_by(fn b -> elem(Enum.at(b, 0), 2) end)

      data = Enum.reduce(data, data, fn d, acc -> fall(d, acc) end)
      no = Enum.reduce(data, MapSet.new(), fn d, acc -> check(d, data, acc) end)
      length(data) - MapSet.size(no)
    end
  end

end

IO.inspect(AoC.solve('input.txt'), label: 'Result')
