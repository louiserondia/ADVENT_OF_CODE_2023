defmodule AoC do
  defp visualizer(data, max_x, max_y) do
    Enum.reduce(0..(max_y - 1), "", fn y, acc ->
      acc <>
        Enum.reduce(0..(max_x - 1), "", fn x, line_acc ->
          c = Enum.find_value(data, fn {{x1, y1}, c} -> if {x1, y1} == {x, y}, do: c end)

          case c do
            nil -> line_acc <> "."
            _ -> line_acc <> c
          end
        end) <> " - " <> Integer.to_string(max_y - y) <> "\n"
    end)
    |> IO.puts()

    data
  end

  defp get_prev(dir, {{x, y}, _}, data, max_x, max_y) do
    res =
      data
      |> Enum.filter(fn {{nx, ny}, _} ->
        case dir do
          n when n in [0, 2] -> nx == x
          _ -> ny == y
        end
      end)
      |> Enum.reverse()

    r =
      Enum.find(res, fn {{nx, ny}, _} ->
        case dir do
          0 -> ny < y
          1 -> nx < x
          2 -> ny > y
          3 -> nx > x
        end
      end)

    case {r, dir} do
      {nil, n} when n <= 1 -> {{0, 0}, "."}
      {nil, 2} -> {{0, max_y - 1}, "."}
      {nil, 3} -> {{max_x - 1, 0}, "."}
      {{{nx, ny}, nc}, 0} -> {{nx, ny + 1}, nc}
      {{{nx, ny}, nc}, 1} -> {{nx + 1, ny}, nc}
      {{{nx, ny}, nc}, 2} -> {{nx, ny - 1}, nc}
      {{{nx, ny}, nc}, 3} -> {{nx - 1, ny}, nc}
    end
  end

  defp tilt(dir, data, max_x, max_y) do
    d =
      case dir do
        n when n in [2, 3] -> Enum.reverse(data)
        _ -> data
      end

    Enum.reduce(d, {0, []}, fn {{x, y}, c}, {i, acc} ->
      case {c, i} do
        {"O", i} when i < length(data) ->
          case dir do
            n when n in [0, 2] ->
              {{_, ny}, _} = get_prev(dir, {{x, y}, c}, acc, max_x, max_y)
              {i + 1, acc ++ [{{x, ny}, c}]}

            _ ->
              {{nx, _}, _} = get_prev(dir, {{x, y}, c}, acc, max_x, max_y)
              {i + 1, acc ++ [{{nx, y}, c}]}
          end

        _ ->
          {i + 1, acc ++ [{{x, y}, c}]}
      end
    end)
    |> elem(1)
  end

  defp score(data, max_y) do
    Enum.reduce(data, 0, fn {{_, y}, c}, acc ->
      case c do
        "O" -> acc + (max_y - y)
        _ -> acc
      end
    end)
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

      max = 102 + rem(1_000_000_000 - 102, 14)

      Enum.reduce(1..(4 * max), data, fn i, acc ->
        tilt(rem(i - 1, 4), acc, max_x, max_y)
        |> Enum.sort(fn {{x1, y1}, _}, {{x2, y2}, _} ->
          if x1 != x2, do: x1 < x2, else: y1 < y2
        end)
      end)
      |> score(max_y)
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "result")
