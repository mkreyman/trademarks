defmodule Trademarks.Utils.DateFormatter do
  def format(params) do
    params
    |> Map.update(:filing_date, params[:filing_date], &to_date(&1))
    |> Map.update(:registration_date, params[:registration_date], &to_date(&1))
    |> Map.update(:renewal_date, params[:renewal_date], &to_date(&1))
    |> Map.update(:date, params[:date], &to_date(&1))
  end

  def is_date(date) do
    try do
      %Date{} = date
      true
    rescue
      MatchError -> false
    end
  end

  defp to_date(string) when byte_size(string) == 0, do: nil
  defp to_date(string) do
    ~r"(\d{4})(\d{2})(\d{2})"
    |> Regex.run(string)
    |> Enum.take(-3)
    |> Enum.join("-")
    |> Date.from_iso8601!()
  end
end