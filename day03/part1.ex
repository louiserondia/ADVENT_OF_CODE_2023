defmodule AoC do
  defp check(prev, [current | next], {[number], i}) do
    b = max(0, i - 1)
    e = min(i + String.length(number), String.length(current) - 1)

    res =
      case {prev, next} do
        {nil, next} ->
          String.at(current, b) <> String.at(current, e) <> String.slice(List.first(next), b..e)

        {prev, []} ->
          String.slice(prev, b..e) <> String.at(current, b) <> String.at(current, e)

        {prev, next} ->
          String.slice(prev, b..e) <>
            String.at(current, b) <> String.at(current, e) <> String.slice(List.first(next), b..e)
      end

    case String.match?(res, ~r/[^0-9.]/) do
      true -> String.to_integer(number)
      false -> 0
    end
  end

  defp solve(_prev, []), do: 0

  defp solve(prev, [current | next]) do
    matches = Regex.scan(~r/\d+/, current)
    index = Regex.scan(~r/\d+/, current, return: :index) |> Enum.map(fn [{i, _b}] -> i end)
    fusion = Enum.zip(matches, index)

    res = Enum.map(fusion, &check(prev, [current | next], &1)) |> Enum.sum()

    res + solve(current, next)
  end

  def read_file(file_path) do
    with {:ok, content} <- File.read(file_path) do
      lines = String.split(content)
      solve(nil, lines)
    end
  end
end

IO.puts("Result : #{AoC.read_file("input.txt")}")
