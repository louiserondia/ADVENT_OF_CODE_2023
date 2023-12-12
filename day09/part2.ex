defmodule AoC do
  defp score(numbers) do
    if Enum.all?(numbers, &(&1 == 0)) do
      0
    else
      new_numbers =
        Enum.reduce(numbers, {nil, []}, fn n, {prev, acc} ->
          case prev do
            nil -> {n, acc}
            _ -> {n, acc ++ [n - prev]}
          end
        end)
        |> elem(1)

      List.first(numbers) - score(new_numbers)
    end
  end

  def solve(file_path) do
    with {:ok, content} <- File.read(file_path) do
      content
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn s ->
        String.split(s)
        |> Enum.map(&String.to_integer(&1))
      end)
      |> Enum.map(&score(&1))
      |> Enum.sum()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
