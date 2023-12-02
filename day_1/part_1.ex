defmodule FileReader do
	def read_file(file_path) do
		case File.read(file_path) do
			{:ok, content} ->
				lines = String.split(content, "\n")
				result = each_line(lines, 0)
				IO.puts("Result : #{result}")
			{:error, reason} ->
				IO.puts("Erreur lors de la lecture du fichier : #{reason}")
		end
	end

	defp scan_line(line) do
		matches = Regex.scan(~r/\d/, line)
		parsed = Enum.join([Enum.at(matches, 0), List.last(matches)])
							|> Integer.parse()
		case parsed do
			{number, _} -> number
			_ ->
				IO.puts("Impossible de convertir en nombre.")
				0
		end
	end

	defp each_line(lines, i) do
		if i < length(lines) do
			res = scan_line(Enum.at(lines, i))
			res + each_line(lines, i + 1)
		else
			0
		end
	end
end

FileReader.read_file("part1.txt")
