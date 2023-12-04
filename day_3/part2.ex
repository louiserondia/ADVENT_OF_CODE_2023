defmodule AoC do
  defp find_coord([b, m1, m2, e], x, y) do
    case Enum.find([b, m1, m2, e], &String.contains?(&1, "*")) do
      nil ->
        {0, 0}

      star ->
        i = Regex.scan(~r/\*/, star, return: :index) |> hd |> Enum.at(0) |> elem(0)

        case star do
          ^b -> {max(x + i - 1, i), y - 1}
          ^m1 -> {x - 1, y}
          ^m2 -> {x + 1, y}
          ^e -> {max(x + i - 1, i), y + 1}
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

    coord = find_coord(res, x, y)
    {number, coord}
  end

  defp solve(_prev, [], _y), do: 0

  defp solve(prev, [current | next], y) do
    matches = Regex.scan(~r/\d+/, current)
    index = Regex.scan(~r/\d+/, current, return: :index) |> Enum.map(fn [{i, _b}] -> i end)
    fusion = Enum.zip(matches, index)

    res =
      Enum.map(fusion, &check(prev, [current | next], &1, y))
      |> Enum.filter(fn {_value, {x, y}} -> {x, y} != {0, 0} end)
      |> Enum.filter(&(length(&1) != 0))
      # |> Enum.group_by(&elem(&1, 1))
      # |> Enum.filter(&length(elem(&1, 1)) > 1)
      # |> Map.values()
      # |> Enum.filter(fn {_key, values} -> length(values) > 1 end)
      # |> Enum.flat_map(&tl(&1))
      # |> Enum.map(&elem(&1, 0))

    IO.inspect(res)
    solve(current, next, y + 1)
  end

  def read_file(file_path) do
    with {:ok, content} <- File.read(file_path) do
      lines = String.split(content)
      solve(nil, lines, 0)
    end
  end
end

IO.puts("Result : #{AoC.read_file("input/part1.txt")}")
