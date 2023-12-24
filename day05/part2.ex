defmodule AoC do
  defp compute(seed, []), do: seed

  defp compute(seed, [conv | tail]) do
    case Enum.find(conv, fn [_, s, l] -> seed in s..(s + l - 1) end) do
      nil -> compute(seed, tail)
      [d, s, _] -> compute(d + (seed - s), tail)
    end
  end

  def solve(path) do
    with {:ok, content} <- File.read(path) do
      [head | tail] =
        content
        |> String.trim()
        |> String.replace("\r", "")
        |> String.split("\n\n")

      conv =
        tail
        |> Enum.map(fn lines ->
          lines
          |> String.split("\n")
          |> Enum.drop(1)
          |> Enum.map(fn line ->
            line
            |> String.split()
            |> Enum.map(&String.to_integer(&1))
          end)
        end)

      seeds =
        head
        |> String.split()
        |> Enum.drop(1)
        |> Enum.map(&String.to_integer(&1))
        |> Enum.chunk_every(2)

      Enum.map(seeds, fn [s, r] ->
        0..r
        |> Enum.map(fn i -> compute(s + i, conv) end)
        |> Enum.min()
      end)
      |> Enum.min()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result", charlists: :as_lists)
