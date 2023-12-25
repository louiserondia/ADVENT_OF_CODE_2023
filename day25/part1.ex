defmodule AoC do
  defp traverse(data, elem, res, cache) do
    # IO.inspect(elem)
    # IO.inspect(cache)

    data
    |> Enum.reduce([], fn {k, v}, acc ->
      case v |> Enum.member?(elem) || elem == k do
        true -> acc ++ [{k, v}]
        _ -> acc
      end
    end)
    |> Enum.map(fn {k, v} ->
      if Enum.member?(cache, {k, v}) do
        res
      else
        res = res |> MapSet.put(k)
        cache = cache |> MapSet.put({k, v})

        # |> IO.inspect()
        # res = res |> MapSet.put(e)

        v
        |> Enum.map(fn e ->
          if e == elem do
            res
          else
            traverse(data, e, res, cache)
          end
        end)

        traverse(data, k, res, cache)
        res
      end
    end)
  end

  def solve(path) do
    with {:ok, content} <- File.read(path) do
      data =
        content
        |> String.trim()
        |> String.replace("\r", "")
        |> String.split("\n")
        |> Enum.map(&String.split(&1, ":"))
        |> Enum.reduce(%{}, fn [k, v], acc ->
          v = v |> String.split()
          Map.put(acc, k, v)
        end)

      traverse(data, Map.keys(data) |> List.first(), MapSet.new(), MapSet.new())
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
