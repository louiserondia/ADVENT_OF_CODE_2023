defmodule AoC do
  def read_file(file_path) do
    with {:ok, content} <- File.read(file_path) do
      String.split(content, "\n")
      |> Enum.map(&String.split(&1, ":"))
      |> Enum.map(&solve/1)
      |> Enum.sum()
    end
  end

  defp check(n, "red") when n > 12, do: true
  defp check(n, "green") when n > 13, do: true
  defp check(n, "blue") when n > 14, do: true
  defp check(_, _), do: false

  defp solve([head | tail]) do
    trimed = String.replace(head, "Game ", "") |> String.to_integer()

    res =
      Enum.join(tail)
      |> String.split(~r/[;,]/)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn [head | rest] -> [String.to_integer(head) | rest] end)
      |> Enum.map(fn [head | rest] -> check(head, Enum.join(rest)) end)

    if Enum.any?(res), do: 0, else: trimed
  end
end

IO.puts("Result : #{AoC.read_file("input/part1.txt")}")
