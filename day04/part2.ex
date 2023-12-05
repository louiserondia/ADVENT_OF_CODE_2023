defmodule AoC do
  defp solve([], _, res, _), do: res

  defp solve([head_base | tail_base], [head_it | _], res, i) do
    new_res =
      Enum.with_index(res)
      |> Enum.map(fn {el, it} ->
        if it >= i && it < i + head_base, do: el + 1, else: el
      end)

    [new_hit | new_tit] =
      List.duplicate(head_it, 1) ++ (new_res |> Enum.slice(i..length(new_res)))

    if head_it > 1 do
      solve([head_base | tail_base], [new_hit - 1 | new_tit], new_res, i)
    else
      solve(tail_base, new_tit, new_res, i + 1)
    end
  end

  def read_file(file_path) do
    with {:ok, content} <- File.read(file_path) do
      res =
        String.split(content, "\n", trim: true)
        |> Enum.map(fn line -> String.split(line, ":") |> Enum.at(1) end)
        |> Enum.map(&String.split(&1, "|", trim: true))
        |> Enum.map(fn line ->
          Enum.map(line, fn each_side ->
            String.split(each_side)
            |> Enum.map(&String.to_integer(&1))
          end)
        end)
        |> Enum.map(fn [left, right] ->
          Enum.map(left, fn el -> if Enum.member?(right, el), do: el end)
          |> Enum.filter(&(&1 != nil))
        end)
        |> Enum.map(&length(&1))

      solve(res, List.duplicate(1, length(res)), List.duplicate(1, length(res)), 1)
      |> Enum.sum()
    end
  end
end

IO.puts("Result : #{AoC.read_file("input/part1.txt")}")
