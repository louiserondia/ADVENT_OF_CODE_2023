defmodule AoC do
  defp solve([], path, str, copy), do: solve(copy, path, str, copy)

  defp solve([h | t], path, str, copy) do
    case String.ends_with?(str, "Z") do
      true ->
        0

      _ ->
        new =
          if h == "L", do: path[str] |> Enum.at(0), else: path[str] |> Enum.at(1)

        1 + solve(t, path, new, copy)
    end
  end

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

      allAs =
        Map.keys(path)
        |> Enum.filter(&String.ends_with?(&1, "A"))

      Enum.map(allAs, &solve(rules, path, &1, rules))
      |> Enum.reduce(1, fn n, lcd ->
        div(n * lcd, Integer.gcd(n, lcd))
      end)
    end
  end
end

IO.inspect(AoC.read_file("input.txt"), label: "Result")
