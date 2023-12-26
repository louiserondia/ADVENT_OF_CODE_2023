defmodule AoC do
  defp compute(n, [], seeds) do
    Enum.reduce(seeds, false, fn [s, r], acc ->
      case acc do
        true -> true
        _ -> n in s..(s + r - 1)
      end
    end)
  end

  defp compute(n, [conv | tail], seeds) do
    case Enum.find(conv, fn [s, _, l] -> n in s..(s + l - 1) end) do
      nil -> compute(n, tail, seeds)
      [s, d, _] -> compute(d + (n - s), tail, seeds)
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

      0..99_999_999
      |> Enum.reduce_while(0, fn i, acc ->
        case compute(i, conv, seeds) do
          true -> {:halt, i}
          _ -> {:cont, acc}
        end
      end)
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result", charlists: :as_lists)
