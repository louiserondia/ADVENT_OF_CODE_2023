defmodule FileReader do
  def read_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        result =
          String.split(content, "\n")
          |> Enum.map(fn x -> String.split(x, ":") end)
          |> Enum.map(&parse_line/1)
          |> Enum.sum()

        IO.inspect(result, label: "Result ")

      {:error, reason} ->
        IO.puts("Erreur lors de la lecture du fichier : #{reason}")
    end
  end

  defp biggest([], red, green, blue) do
    red * green * blue
  end

  defp biggest([head | tail], red, green, blue) do
    case head do
      [n, "red"] when n > red -> biggest(tail, n, green, blue)
      [n, "green"] when n > green -> biggest(tail, red, n, blue)
      [n, "blue"] when n > blue -> biggest(tail, red, green, n)
      _ -> biggest(tail, red, green, blue)
    end
  end

  defp parse_line([_head | tail]) do
    splited =
      Enum.join(tail)
      |> String.split(~r/[;,]/)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn [head | rest] -> [String.to_integer(head) | rest] end)

    case splited do
      [head | tail] -> biggest([head | tail], 0, 0, 0)
    end
  end
end

FileReader.read_file("input/part1.txt")
