defmodule AoC do
  defp hash(s) do
    s
    |> to_charlist()
    |> Enum.reduce(0, fn n, acc -> rem((acc + n) * 17, 256) end)
  end

  def solve(path) do
    with {:ok, content} <- File.read(path) do
      content
      |> String.trim()
      |> String.split(",")
      |> Enum.reduce(%{}, fn s, acc ->
        [label, lens] = s |> String.split(~r{=|-})
        h = label |> hash()

        case [lens, acc[h]] do
          ["", nil] ->
            acc

          ["", _] ->
            acc
            |> Map.replace(h, acc[h] |> List.delete(Enum.find(acc[h], fn {l, _} -> l == label end)))

          [lens, nil] ->
            acc |> Map.put(h, [{label, lens}])

          [lens, _] ->
            case acc[h] |> Enum.find_index(fn {l, _} -> l == label end) do
              nil -> acc |> Map.replace(h, acc[h] |> List.insert_at(-1, {label, lens}))
              i -> acc |> Map.replace(h, acc[h] |> List.replace_at(i, {label, lens}))
            end
        end
      end)
      |> Enum.reduce(0, fn {k, v}, acc ->
        acc +
          (v
           |> Enum.reduce({0, 1}, fn {_, lens}, {acc, i} ->
             {acc + (k + 1) * i * String.to_integer(lens), i + 1}
           end)
           |> elem(0))
      end)
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
