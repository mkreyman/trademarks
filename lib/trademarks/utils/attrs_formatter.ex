defmodule Trademarks.Utils.AttrsFormatter do
  def format(attrs) do
    attrs
    |> format_date()
    |> upcase()
  end

  def is_date(date) do
    try do
      %Date{} = date
      true
    rescue
      MatchError -> false
    end
  end

  defp upcase(%{trademark_name: _} = attrs) do
    attrs
    |> Map.update(:trademark_name, attrs[:trademark_name], &String.upcase(&1))
  end

  defp upcase(%{name: _} = attrs) do
    attrs
    |> Map.update(:name, attrs[:name], &String.upcase(&1))
  end

  defp upcase(%{address_1: _} = attrs) do
    attrs
    |> Map.update(:address_1, attrs[:address_1], &String.upcase(&1))
  end

  defp upcase(attrs), do: attrs

  defp format_date(attrs) do
    attrs
    |> Map.update(:status_date, attrs[:status_date], &to_date(&1))
    |> Map.update(:filing_date, attrs[:filing_date], &to_date(&1))
    |> Map.update(:registration_date, attrs[:registration_date], &to_date(&1))
    |> Map.update(:renewal_date, attrs[:renewal_date], &to_date(&1))
    |> Map.update(:abandonment_date, attrs[:abandonment_date], &to_date(&1))
    |> Map.update(:date, attrs[:date], &to_date(&1))
  end

  defp to_date(nil), do: nil
  defp to_date(string) when byte_size(string) == 0, do: nil
  defp to_date(%Date{} = date), do: date

  defp to_date(string) do
    ~r"(\d{4})(\d{2})(\d{2})"
    |> Regex.run(string)
    |> Enum.take(-3)
    |> Enum.join("-")
    |> Date.from_iso8601!()
  end
end
