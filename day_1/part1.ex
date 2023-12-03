defmodule AoC do
  defp scan_line(line) do
    matches = Regex.scan(~r/\d/, line)

    Enum.join([List.first(matches), List.last(matches)])|> String.to_integer()
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

IO.puts("Result : #{AoC.read_file("input/part1.txt")}")
