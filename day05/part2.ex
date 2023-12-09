defmodule AoC do
  defp location(num, []), do: num

  defp location(num, [block | tail]) do
    _num =
      case Enum.find(block, fn [_d, s, l] -> num in s..(s + l - 1) end) do
        nil -> location(num, tail)
        [d, s, _l] -> location(d + (num - s), tail)
      end
    end

  defp solve(%{head => 0} = map, []), do: num

  defp solve(%{head => tail} = map, [block | tail]) do


  end

  def read_file(file_path) do
    with {:ok, content} <- File.read(file_path) do
      [head | tail] = String.split(content, "\r\n\r\n")

      conv =
        Enum.map(tail, fn block ->
          String.split(block, "\r\n")
          |> Enum.drop(1)
          |> Enum.map(fn line ->
            String.split(line)
            |> Enum.map(&String.to_integer(&1))
          end)
        end)

      seeds =
        String.split(head)
        |> Enum.drop(1)
        |> Enum.map(&String.to_integer(&1))
        |> Enum.chunk_every(2, 2, :discard)
        # |> Enum.reduce(%{}, fn [key, value], acc -> Map.put(acc, key, value) end)
        |> Enum.map(& Range.new(&1 |> List.first(), &1 |> List.last()))

      Enum.map(seeds, &solve(&1, conv))
      |> Enum.min()
      |> IO.inspect(label: "Result ")
    end
  end
end

AoC.read_file("input.txt")
