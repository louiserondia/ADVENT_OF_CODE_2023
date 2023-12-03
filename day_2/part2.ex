defmodule AoC do
  defp biggest([], red, green, blue), do: red * green * blue

  defp biggest([head | tail], red, green, blue) do
    case head do
      [n, "red"] when n > red -> biggest(tail, n, green, blue)
      [n, "green"] when n > green -> biggest(tail, red, n, blue)
      [n, "blue"] when n > blue -> biggest(tail, red, green, n)
      _ -> biggest(tail, red, green, blue)
    end
  end

  defp solve([_head | tail]) do
    splited =
      Enum.join(tail)
      |> String.split(~r/[;,]/)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn [head | rest] -> [String.to_integer(head) | rest] end)

    biggest(splited, 0, 0, 0)
  end

  def read_file(file_path) do
    with {:ok, content} <- File.read(file_path) do
      String.split(content, "\n")
      |> Enum.map(&String.split(&1, ":"))
      |> Enum.map(&solve/1)
      |> Enum.sum()
    end
  end
end

IO.puts("Result : #{AoC.read_file("input/part1.txt")}")
