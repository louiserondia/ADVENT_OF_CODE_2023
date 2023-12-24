defmodule AoC do
  defp compute(n, [], _seeds) do
    n
  end

  defp compute(n, [conv | tail], seeds) do
    case Enum.find(conv, fn [_, s, l] -> n in s..(s + l - 1) end) do
      nil -> compute(n, tail, seeds)
      [d, s, _] -> compute(d + (n - s), tail, seeds)
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
        |> Enum.reverse()

      seeds =
        head
        |> String.split()
        |> Enum.drop(1)
        |> Enum.map(&String.to_integer(&1))
        |> Enum.chunk_every(2)

      0..999
      |> Enum.map(&compute(&1, conv, seeds))
      |> Enum.filter(fn n ->
        Enum.reduce(seeds, false, fn [s, r], acc ->
          case acc do
            true -> true
            _ -> n in s..(s + r - 1)
          end
        end) == true
      end)

      # |> Enum.min()

      # Enum.map(seeds, fn [s, r] ->
      #   0..r
      #   |> Enum.map(fn i -> compute(s + i, conv) end)
      #   |> Enum.min()
      # end)
      # |> Enum.min()
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result", charlists: :as_lists)
