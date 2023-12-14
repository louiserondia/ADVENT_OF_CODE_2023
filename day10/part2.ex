defmodule AoC do
  def solve(file_path) do
    with {:ok, content} <- File.read(file_path) do
      data =
      content
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.trim(&1))
      |> Enum.with_index()
      |> Enum.flat_map(fn {s, y} ->
        s
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {c, x} ->
          {{x, y}, c}
        end)
      end)
      |> Enum.reduce(%{}, fn {k, v}, acc -> acc |> Map.put(k, v) end)

      dirs = %{
        n: {0, -1},
        s: {0, 1},
        w: {-1, 0},
        e: {1, 0}
      }

      pipes = %{
        "F" => %{dirs.n => dirs.e, dirs.w => dirs.s},
        "-" => %{dirs.e => dirs.e, dirs.w => dirs.w},
        "7" => %{dirs.e => dirs.s, dirs.n => dirs.w},
        "|" => %{dirs.s => dirs.s, dirs.n => dirs.n},
        "J" => %{dirs.s => dirs.w, dirs.e => dirs.n},
        "L" => %{dirs.s => dirs.e, dirs.w => dirs.n}
      }

      {x0, y0} = data |> Enum.find(fn {_, v} -> v == "S" end) |> elem(0)

      pipe0 =
        pipes
        |> Map.keys()
        |> Enum.find(fn c ->
          pipes[c]
          |> Map.values()
          |> Enum.all?(fn {dx, dy} ->
            pipes[data[{x0 + dx, y0 + dy}]] |> Map.values() |> Enum.member?({dx * -1, dy * -1})
          end)
        end)

      data = data |> Map.put({x0, y0}, pipe0)
      d0 = pipes[pipe0] |> Map.values() |> Enum.at(0)

      loop =
        Stream.iterate(0, &(&1 + 1))
        |> Enum.reduce_while({{x0, y0}, d0, MapSet.new()}, fn _, {{px, py}, {dx, dy}, loop} ->
          loop = loop |> MapSet.put({px, py})

          case {px + dx, py + dy} do
            {^x0, ^y0} -> {:halt, loop}
            {px, py} -> {:cont, {{px, py}, pipes[data[{px, py}]][{dx, dy}], loop}}
          end
        end)

      {w, h} = data |> Map.keys() |> Enum.max(fn {lx, ly}, {rx, ry} -> lx + ly > rx + ry end)

      0..h
      |> Enum.map(fn y ->
        0..w
        |> Enum.reduce({0, false, "|"}, fn x, {n, b, prev} ->
          {b, prev} =
            case {loop |> MapSet.member?({x, y}), prev, data[{x, y}]} do
              {false, _, _} -> {b, prev}
              {_, _, "-"} -> {b, prev}
              {_, _, "|"} -> {not b, "|"}
              {_, "L", "7"} -> {not b, "7"}
              {_, "F", "J"} -> {not b, "J"}
              {_, _, c} -> {b, c}
            end

          case {MapSet.member?(loop, {x, y}), b} do
            {false, true} -> {n + 1, b, prev}
            _ -> {n, b, prev}
          end
        end)
      end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.sum()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
