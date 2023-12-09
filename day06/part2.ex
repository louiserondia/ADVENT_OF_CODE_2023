defmodule AoC do

	defp solve(start, [t, d]) when ((t - start) * start) <= d, do: 0

	defp solve(start, [t, d]) when start == round(t / 2) do
		1 + solve(start + 1, [t, d]) + solve(start - 1, [t, d])
	end

	defp solve(start, [t, d]) when start > round(t / 2) do
		1 + solve(start + 1, [t, d])
	end

	defp solve(start, [t, d]) when start < round(t / 2) do
		1 + solve(start - 1, [t, d])
	end

	def read_file(file_path) do
		with {:ok, content} <- File.read(file_path) do
			[t, d] = String.split(content, "\r\n")
			|> Enum.map(fn line -> String.split(line, ":")
				|> Enum.at(1)
				|> String.split()
				|> Enum.join()
				|> String.to_integer()
			end)

			solve(round(t / 2), [t, d])
		end
	end
end

IO.inspect(AoC.read_file("input.txt"), label: "Result")
