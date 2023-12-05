defmodule AoC do
  defp convert_to_number(word) do
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
    first = Regex.run(regex_pattern, line) |> hd()
    last = Regex.run(reverse_regex_pattern, String.reverse(line)) |> hd() |> String.reverse()

    Enum.join([convert_to_number(first), convert_to_number(last)])
    |> String.to_integer()
  end

  defp solve(lines, i) when i < length(lines) do
    res = scan_line(Enum.at(lines, i))
    res + solve(lines, i + 1)
  end

  defp solve(_, _), do: 0

  def read_file(file_path) do
    with {:ok, content} <- File.read(file_path) do
      lines = String.split(content, "\n")
      solve(lines, 0)
    end
  end
end

IO.puts("Result : #{AoC.read_file("input/part2.txt")}")
