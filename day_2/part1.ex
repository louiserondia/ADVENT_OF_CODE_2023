defmodule FileReader do
	def read_file(file_path) do
		case File.read(file_path) do
			{:ok, content} ->
				result = String.split(content, "\n")
                  |> Enum.map(fn x -> String.split(x, ":") end)
                  |> Enum.map(&parse_line/1)
                  |> Enum.filter(&(&1 != 0))
                  |> Enum.sum()

        IO.inspect(result, label: "Result ")
			{:error, reason} ->
				IO.puts("Erreur lors de la lecture du fichier : #{reason}")
		end
	end

  defp too_much(n, color) do
    case [n, color] do
      [n, "red"] when n > 12 -> true
      [n, "green"] when n > 13 -> true
      [n, "blue"] when n > 14 -> true
      _ -> false
    end
  end

  defp parse_line([head | tail]) do
    trimed =  String.replace(head, "Game ", "") |> String.to_integer()
    splited = Enum.join(tail)
              |> String.split(~r/[;,]/)
              |> Enum.map(&String.trim/1)
              |> Enum.map(&String.split(&1, " "))
              |> Enum.map(fn [head | rest] -> [String.to_integer(head) | rest] end)

    res = Enum.map(splited, fn [head | rest] -> too_much(head, Enum.join(rest)) end)
    case Enum.any?(res, &(&1)) do
      true -> 0
      false -> trimed
    end
  end

end

FileReader.read_file("input/part1.txt")
