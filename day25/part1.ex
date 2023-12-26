defmodule AoC do
  defp check_links(group, data, duos) do
    if group
       |> Enum.reduce(0, fn e, acc ->
           acc +
             (duos
              |> Enum.count(fn {l, r} ->
                (e == l && not Enum.member?(group, r)) || (e == r && not Enum.member?(group, l))
              end))
       end) == 3 do
      IO.inspect(length(group) * (map_size(data) - length(group)))
    end
  end

  defp group(group, elem, n, data, duos) do
      unless length(group) == map_size(data) do
      group = group ++ [elem]
      if check_links(group, data, duos) == nil do

        data[elem]
        |> Enum.map(fn e ->
          unless group |> Enum.member?(e) do
            group(group, e, n + 1, data, duos)
          end
        end)
      end
    end
    1
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

          acc =
            case acc[k] do
              nil -> acc |> Map.put(k, v)
              r -> acc |> Map.replace(k, ([r] ++ [v]) |> List.flatten())
            end

          v
          |> Enum.reduce(acc, fn val, a ->
            case a[val] do
              nil -> a |> Map.put(val, k)
              res -> a |> Map.replace(val, ([res] ++ [k]) |> List.flatten())
            end
          end)
        end)

      duos =
        data
        |> Enum.reduce(MapSet.new(), fn {k, v}, a ->
          v
          |> Enum.reduce(a, fn val, acc ->
            case acc
                 |> Enum.find(fn {l, r} -> (k == l && val == r) || (k == r && val == l) end) do
              nil -> acc |> MapSet.put({k, val})
              _ -> acc
            end
          end)
        end)

      # Agent.start_link(fn -> MapSet.new() end, name: :group_cache)
      # Agent.get(:group_cache, & MapSet.size/1)
      group([], data |> Map.keys() |> List.last(), 1, data, duos)
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
