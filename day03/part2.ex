defmodule AoC do
  defp find_coord([up, left, right, down], x, y, len) do
    case Enum.find([up, left, right, down], &String.contains?(&1, "*")) do
      nil ->
        {0, 0}

      star ->
        i = Regex.scan(~r/\*/, star, return: :index) |> hd |> Enum.at(0) |> elem(0)

        case star do
          ^up -> {max(x + i - 1, i), y - 1}
          ^left -> {x - 1, y}
          ^right -> {x + len, y}
          ^down -> {max(x + i - 1, i), y + 1}
        end
    end
  end

  defp check(prev, [current | next], {[number], x}, y) do
    b = max(0, x - 1)
    e = min(x + String.length(number), String.length(current) - 1)

    res =
      case {prev, next} do
        {nil, next} ->
          ["", String.at(current, b), String.at(current, e), String.slice(List.first(next), b..e)]

        {prev, []} ->
          [String.slice(prev, b..e), String.at(current, b), String.at(current, e), ""]

        {prev, next} ->
          [
            String.slice(prev, b..e),
            String.at(current, b),
            String.at(current, e),
            String.slice(List.first(next), b..e)
          ]
      end

    coord = find_coord(res, x, y, String.length(number))
    {number, coord}
  end

  defp solve(_prev, [], _y, l), do: l

  defp solve(prev, [current | next], y, l) do
    matches = Regex.scan(~r/\d+/, current)
    index = Regex.scan(~r/\d+/, current, return: :index) |> Enum.map(fn [{i, _b}] -> i end)
    fusion = Enum.zip(matches, index)

    res =
      Enum.map(fusion, &check(prev, [current | next], &1, y))
      |> Enum.filter(fn {_value, {x, y}} -> {x, y} != {0, 0} end)

    solve(current, next, y + 1, l ++ res)
  end

  def read_file(file_path) do
    with {:ok, content} <- File.read(file_path) do
      lines = String.split(content)

      solve(nil, lines, 0, [])
      |> Enum.group_by(&elem(&1, 1))
      |> Map.values()
      |> Enum.filter(&(&1 |> length == 2))
      |> Enum.map(fn [{n1, _}, {n2, _}] -> String.to_integer(n1) * String.to_integer(n2) end)
      |> Enum.sum()
    end
  end
end

IO.puts("Result : #{AoC.read_file("input.txt")}")
