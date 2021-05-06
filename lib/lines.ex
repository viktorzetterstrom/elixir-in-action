defmodule Lines do
  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&(String.length(&1) >= 80))
  end

  def lines_length!(path) do
    File.stream!(path) |> Stream.map(&String.length/1) |> Enum.to_list()
  end

  def longest_line!(path) do
    lines_length!(path) |> Enum.max()
  end

  def words_per_line!(path) do
    File.stream!(path) |> Stream.map(&length(String.split(&1))) |> Enum.to_list()
  end
end
