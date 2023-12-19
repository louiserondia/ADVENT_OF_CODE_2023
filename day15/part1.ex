defmodule AoC do
  def solve(path) do
    with {:ok, content} <- File.read(path) do
      content
      |> String.trim()
      |> String.split(",")
      |> Enum.map(fn s ->
        s
        |> to_charlist()
        |> Enum.reduce(0, fn n, acc -> acc = rem((acc + n) * 17, 256) end)
      end)
      |> Enum.sum()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
