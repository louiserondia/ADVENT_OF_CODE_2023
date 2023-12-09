defmodule AoC do
  defp solve(num, []), do: num

  defp solve(num, [block | tail]) do
    _num =
      case Enum.find(block, fn [_d, s, l] -> num in s..(s + l - 1) end) do
        nil -> solve(num, tail)
        [d, s, _l] -> solve(d + (num - s), tail)
      end
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

      Enum.map(seeds, &solve(&1, conv))
      |> Enum.min()
      |> IO.inspect(label: "Result ")
    end
  end
end

AoC.read_file("input.txt")
