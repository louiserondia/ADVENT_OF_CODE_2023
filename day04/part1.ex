defmodule AoC do
  def read_file(file_path) do
    with {:ok, content} <- File.read(file_path) do
      String.split(content, "\n", trim: true)
      |> Enum.map(fn line -> String.split(line, ":") |> Enum.at(1) end)
      |> Enum.map(&String.split(&1, "|", trim: true))
      |> Enum.map(fn line ->
        Enum.map(line, fn each_side ->
          String.split(each_side)
          |> Enum.map(&String.to_integer(&1))
        end)
      end)
      |> Enum.map(fn [left, right] ->
        Enum.map(left, fn el -> if Enum.member?(right, el), do: el end)
        |> Enum.filter(&(&1 != nil))
      end)
      |> Enum.map(&(:math.pow(2, length(&1) - 1) |> floor()))
      |> Enum.sum()
    end
  end
end

IO.puts("Result : #{AoC.read_file("input.txt")}")
