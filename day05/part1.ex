










defmodule AoC do

	defp solve(num, []), do: num

	defp solve(num, [block | tail]) do
		interesting = Enum.map(block, fn [d, s, l] ->
			if s <= num && num < s + l, do: [d, s, l]
		end)
		|> Enum.filter(&(&1)) |> elem(0)
		# elem(0) ou hd() ????? pour recup le dsl

		case interesting do
			[d, s, l] ->
				res = d + (num - s)
				solve(res, tail)
			_ -> solve(num, tail)
		end
	end

	def read_file(file_path) do
		with {:ok, content} <- File.read(file_path) do
			[seeds | converts] = String.split(content, "\n\n")

			parsed_conv =
				Enum.map(converts, fn a ->
					String.split(a, "\n")
					|> Enum.drop(b, 1)
					|> Enum.map(fn c ->
						String.split(c)
						|> Enum.map(&String.to_integer(&1))
					end)
				end)

			parsed_seeds = String.split(seeds)
			|> Enum.drop(1)
			|> Enum.map(&String.to_integer(&1))

			Enum.map(parsed_seeds, fn seeds -> solve(seeds, parsed_conv, 0) end)
			|> Enum.min()

		end
	end
end

IO.puts("Result : #{AoC.read_file("part1.txt")}")
