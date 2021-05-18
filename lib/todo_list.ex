defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(entries, %TodoList{}, &add_entry(&2, &1))
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)

    %TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def update_entry(todo_list, entry_id, updater_lambda) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_lambda.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end
end

defmodule TodoList.CsvImporter do
  @spec parse(path :: String.t()) :: %TodoList{}
  def parse(path) do
    File.stream!(path)
    |> parse_file()
    |> Stream.map(&parse_row/1)
    |> TodoList.new()
  end

  defp parse_file(file_stream) do
    file_stream
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, ","))
  end

  defp parse_row([date_string, title]) do
    [year, month, day] =
      date_string
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)

    case Date.new(year, month, day) do
      {:ok, date} -> %{date: date, title: title}
    end
  end
end
