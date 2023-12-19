defmodule AoC do
  defp visualizer(data, max_x, max_y) do
    Enum.reduce(0..max_y - 1, "", fn y, acc ->
      acc <>
        Enum.reduce(0..max_x - 1, "", fn x, line_acc ->
          char = Enum.find_value(data, fn {{x1, y1}, c} -> if {x1, y1} == {x, y}, do: c end)

          case char do
            nil -> line_acc <> "."
            _ -> line_acc <> char
          end
        end) <> " - " <> Integer.to_string(max_y - y) <> "\n"
    end)
    |> IO.puts()

    data
  end

  defp get_prev({{x, y}, _}, data, i) do
    res =
      data
      |> Enum.filter(fn {{nx, _}, _} -> nx == x end)
      |> Enum.split(i)
      |> elem(0)
      |> Enum.reverse()

    r = Enum.find(res, fn {{_, ny}, _} -> ny < y end)

    case r do
      nil -> {{0, -1}, "."}
      {{nx, ny}, nc} -> {{nx, ny}, nc}
    end
  end

  def solve(path) do
    with {:ok, content} <- File.read(path) do
      lines =
        content
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&String.trim(&1))

      {max_x, max_y} = {String.length(Enum.at(lines, 0)), length(lines)}

      data =
        Enum.with_index(lines)
        |> Enum.flat_map(fn {s, y} ->
          s
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.filter(fn {v, _x} -> v != "." end)
          |> Enum.map(fn {c, x} -> {{x, y}, c} end)
        end)

      res =
        Enum.reduce(data, {0, []}, fn {{x, y}, c}, {i, acc} ->
          case {c, i} do
            {"O", i} when i < length(data) ->
              {{_, ny}, _} = get_prev({{x, y}, c}, acc, i)
              {i + 1, acc ++ [{{x, ny + 1}, c}]}

            _ ->
              {i + 1, acc ++ [{{x, y}, c}]}
          end
        end)
        |> elem(1)
        |> visualizer(max_x, max_y)

      Enum.reduce(res, 0, fn {{_, y}, c}, acc ->
        case c do
          "O" -> acc + (max_y - y)
          _ -> acc
        end
      end)
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "result")
