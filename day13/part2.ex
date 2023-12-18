defmodule AoC do
  def diff(s1, s2) do
    Enum.zip(String.graphemes(s1), String.graphemes(s2))
    |> Enum.reduce(0, fn {c1, c2}, acc -> if c1 != c2, do: acc + 1, else: acc end)
  end

  defp horizontal(_, [], _), do: nil

  defp horizontal(copy, [_ | tail], i) do
    {s1, s2} = Enum.split(copy, i)

    case Enum.zip(Enum.reverse(s1), s2)
         |> Enum.map(fn {l, r} -> diff(l, r) end)
         |> Enum.sum() do
      1 -> i
      _ -> horizontal(copy, tail, i + 1)
    end
  end

  defp vertical(copy, [], i, c) do
    case c do
      1 -> i
      _ -> vertical(copy, copy, i + 1, 0)
    end
  end

  defp vertical(copy, [head | tail], i, c) do
    {s1, s2} = String.split_at(head, i)

    if s2 != "" do
      res =
        (String.starts_with?(s2, String.reverse(s1)) && String.length(s1) <= String.length(s2)) ||
          (String.ends_with?(s1, String.reverse(s2)) && String.length(s1) >= String.length(s2))

      case {res, c} do
        {true, _} -> vertical(copy, tail, i, c)
        {_, 0} -> vertical(copy, tail, i, c + 1)
        _ -> vertical(copy, copy, i + 1, 0)
      end
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
        |> Enum.map(&horizontal(&1, &1, 1))
        |> Enum.filter(& &1)
        |> Enum.map(&(&1 * 100))
        |> Enum.sum()

      v =
        data
        |> Enum.map(&vertical(&1, &1, 1, 0))
        |> Enum.filter(& &1)
        |> Enum.sum()

      h + v
    end
  end
end

IO.inspect(AoC.solve("input.txt"), label: "Result")
