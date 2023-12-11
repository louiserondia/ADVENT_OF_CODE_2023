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
          |> Enum.filter(fn {c, _} -> c != "." end)
          |> Enum.map(fn {c, x} ->
            {{x, y}, c}
          end)
        end)
        |> Enum.reduce(%{}, fn {k, v}, acc -> acc |> Map.put(k, v) end)

      dirs = %{
        "n" => {0, -1},
        "s" => {0, 1},
        "w" => {-1, 0},
        "e" => {1, 0}
      }

      pipes = %{
        "F" => %{dirs["n"] => dirs["e"], dirs["w"] => dirs["s"]},
        "-" => %{dirs["e"] => dirs["e"], dirs["w"] => dirs["w"]},
        "7" => %{dirs["e"] => dirs["s"], dirs["n"] => dirs["w"]},
        "|" => %{dirs["s"] => dirs["s"], dirs["n"] => dirs["n"]},
        "J" => %{dirs["s"] => dirs["w"], dirs["e"] => dirs["n"]},
        "L" => %{dirs["s"] => dirs["e"], dirs["w"] => dirs["n"]}
      }

      p0 = data |> Enum.find(fn {_, v} -> v == "S" end) |> elem(0)

      d0 =
        "nswe"
        |> String.graphemes()
        |> Enum.find(fn c ->
          {dx, dy} = dirs[c]
          {x, y} = p0
          {nx, ny} = {x + dx, y + dy}
          {dx, dy} = {dx * -1, dy * -1}

          case data[{nx, ny}] do
            nil -> false
            c -> pipes[c] |> Map.values() |> Enum.member?({dx, dy})
          end
        end)

      res =
        Stream.iterate(0, &(&1 + 1))
        |> Enum.reduce_while({p0, dirs[d0]}, fn i, {{px, py}, {dx, dy}} ->
          {px, py} = {px + dx, py + dy}

          cond do
            {px, py} == p0 ->
              {:halt, i}

            true ->
              {dx, dy} = pipes[data[{px, py}]][{dx, dy}]
              {:cont, {{px, py}, {dx, dy}}}
          end
        end)

      div(res, 2) + rem(res, 2)
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
