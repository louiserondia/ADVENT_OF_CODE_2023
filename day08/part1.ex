defmodule AoC do
  defp solve(_, _, "ZZZ", _copy), do: 0
  defp solve([], path, str, copy), do: solve(copy, path, str, copy)
  defp solve(["L" | t], path, str, copy), do: 1 + solve(t, path, path[str] |> Enum.at(0), copy)
  defp solve(["R" | t], path, str, copy), do: 1 + solve(t, path, path[str] |> Enum.at(1), copy)

  def read_file(file_path) do
    with {:ok, content} <- File.read(file_path) do
      [first, next] = String.split(content, "\r\n\r\n")

      rules = String.split(first, "") |> Enum.filter(&(&1 != ""))

      path =
        String.split(next, "\r\n")
        |> Enum.map(fn line ->
          String.split(line, " = (", trim: true)
          |> Enum.map(&String.trim(&1, ")"))
        end)
        |> Enum.reduce(%{}, fn [key, value], acc ->
          {key, value} = {key, String.split(value, ", ")}
          Map.put(acc, key, value)
        end)

      solve(rules, path, "AAA", rules)
    end
  end
end

IO.inspect(AoC.read_file("input.txt"), label: "Result")
