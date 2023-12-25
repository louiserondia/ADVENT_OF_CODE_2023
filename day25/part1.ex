defmodule AoC do
  defp traverse(data, elem) do
    data
    |> Enum.reduce([], fn {k, v}, acc ->
      case v |> Enum.member?(elem) || elem == k do
        true -> acc ++ [[k] ++ [v]]
        _ -> acc
      end
    end)
    |> Enum.map(fn l ->
      unless Agent.get(:cache, fn cache -> MapSet.member?(cache, l) end) do
        Agent.update(:cache, fn cache -> cache |> MapSet.put(l) end)

        l |> Enum.map(fn e -> traverse(data, e) end)
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

      Agent.start_link(fn -> MapSet.new() end, name: :cache)
      traverse(data, Map.keys(data) |> List.first())
      Agent.get(:cache, & &1)
      # 1
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
