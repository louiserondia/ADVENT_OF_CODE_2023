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

	defp to_number(word) do
		case word do
			"one" -> "1"
			"two" -> "2"
			"three" -> "3"
			"four" -> "4"
			"five" -> "5"
			"six" -> "6"
			"seven" -> "7"
			"eight" -> "8"
			"nine" -> "9"
			_ -> word
		end
	end

	defp scan_line(line) do
		regex_pattern = ~r/(one|two|three|four|five|six|seven|eight|nine|\d)/i
		reverse_regex_pattern = ~r/(eno|owt|eerht|ruof|evif|xis|neves|thgie|enin|\d)/i
		reverse_line= String.reverse(line)

		first =  Enum.at(Regex.run(regex_pattern, line), 0)
		last = Enum.at(Regex.run(reverse_regex_pattern, reverse_line), 0) |> String.reverse()
		parsed = Enum.join([to_number(first), to_number(last)])
						|> Integer.parse()
		case parsed do
			{number, _} -> number
			_ -> 0
		end
	end

	defp each_line(lines, i) do
		if i < length(lines) do
			res = scan_line(Enum.at(lines, i))
			res + each_line(lines, i + 1)
		end
		0
	end
end

FileReader.read_file("part2.txt")
