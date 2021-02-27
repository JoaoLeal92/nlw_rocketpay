defmodule Rocketpay.Numbers do
  def sum_from_file(filename) do
    "#{filename}.csv"
    |>File.read()
    |>handle_file()
  end

  defp handle_file({:ok, content}) do
    sum = content
    |>String.split(",")
    |>Stream.map(fn number -> String.to_integer(number) end)
    |>Enum.sum()

    {:ok, %{result: sum}}
  end
  defp handle_file({:error, _reason}), do: {:error, %{message: "Invalid file!"}}
end
