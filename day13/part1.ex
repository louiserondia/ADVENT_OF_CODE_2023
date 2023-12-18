defmodule AoC do
  defp horizontal(_, [], _, _), do: nil

  defp horizontal(copy, [head | tail], prev, i) do
    if head == prev do
      case Enum.take(copy, i)
           |> Enum.reverse()
           |> Enum.zip([head | tail])
           |> Enum.all?(fn {l, r} -> l == r || !l || !r end) do
        true -> i
        _ -> horizontal(copy, tail, head, i + 1)
      end
    else
      horizontal(copy, tail, head, i + 1)
    end
  end

  defp vertical(_, [], i), do: i

  defp vertical(copy, [head | tail], i) do
    {s1, s2} = String.split_at(head, i)

    if s2 != "" &&
         ((String.starts_with?(s2, String.reverse(s1)) && String.length(s1) <= String.length(s2)) ||
            (String.ends_with?(s1, String.reverse(s2)) && String.length(s1) >= String.length(s2))) do
      vertical(copy, tail, i)
    else
      if i <= String.length(head), do: vertical(copy, copy, i + 1), else: nil
    end
  end

  def solve(file_path) do
    with {:ok, content} <- File.read(file_path) do
      data =
        content
        |> String.trim()
        |> String.replace("\r", "")
        |> String.split("\n\n")
        |> Enum.map(&String.split(&1, "\n"))

      h =
        data
        |> Enum.map(&horizontal(&1, &1, "", 0))
        |> Enum.filter(& &1)
        |> Enum.map(&(&1 * 100))
        |> Enum.sum()

      v =
        data
        |> Enum.map(&vertical(&1, &1, 1))
        |> Enum.filter(& &1)
        |> Enum.sum()

      h + v
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
