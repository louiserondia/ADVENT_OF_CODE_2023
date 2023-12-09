defmodule AoC do

	defp solve(start, {t, _}) when start > t, do: 0

	defp solve(start, {t, d}) do
		res = (t - start) * start
		if res > d, do:	1 + solve(start + 1, {t, d}), else:	solve(start + 1, {t, d})
	end

	def read_file(file_path) do
		with {:ok, content} <- File.read(file_path) do
			[time, dist] = String.split(content, "\r\n")
			|> Enum.map(fn line -> String.split(line, ":")
				|> Enum.at(1)
				|> String.split()
				|> Enum.map(&String.to_integer(&1))
			end)
			fusion = Enum.zip(time, dist)

		Enum.map(fusion, &solve(0, &1)) |> Enum.product()
		end
	end
end

IO.inspect(AoC.read_file("input.txt"), label: "Result")
