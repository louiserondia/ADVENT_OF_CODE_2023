defmodule AoC do
  defp links(prev, elem, group, duos) do
    (prev |> Enum.reject(&(&1 == elem))) ++
      Enum.reduce(duos, [], fn {l, r}, acc ->
        cond do
          elem == l and not Enum.member?(group, r) -> acc ++ [r]
          elem == r and not Enum.member?(group, l) -> acc ++ [l]
          true -> acc
        end
      end)
  end

  defp group(_, group, links) when length(links) == 3, do: length(group)

  defp group(duos, group, []) do
    start = Enum.random(group)
    group(duos, [start], links([start], start, [start], duos))
  end

  defp group(duos, group, links) do
    links
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.sort_by(fn {_, n} -> n end, :desc)
    |> Enum.reduce_while(nil, fn {e, _}, _ ->
      case group(duos, [e | group], links(links, e, [e | group], duos)) do
        nil -> {:cont, nil}
        res -> {:halt, res}
      end
    end)
  end

  def solve(path) do
    with {:ok, content} <- File.read(path) do
      duos =
        content
        |> String.trim()
        |> String.replace("\r", "")
        |> String.split("\n")
        |> Enum.map(&String.split(&1, ":"))
        |> Enum.reduce(MapSet.new(), fn [k, v], a ->
          v
          |> String.split()
          |> Enum.reduce(a, fn val, acc ->
            case acc
                 |> Enum.find(fn {l, r} -> (k == l && val == r) || (k == r && val == l) end) do
              nil -> acc |> MapSet.put({k, val})
              _ -> acc
            end
          end)
        end)

      all =
        duos
        |> Enum.reduce(MapSet.new(), fn {l, r}, acc -> acc |> MapSet.put(l) |> MapSet.put(r) end)

      case group(duos, all |> MapSet.to_list(), []) do
        r -> r * (MapSet.size(all) - r)
      end
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
