defmodule Trademarks.Utils.ParamsFormatter do
  def format(params) do
    params
    |> format_date()
    |> to_json()
  end

  def is_date(date) do
    try do
      %Date{} = date
      true
    rescue
      MatchError -> false
    end
  end

  defp format_date(params) do
    params
    |> Map.update(:filing_date, params[:filing_date], &to_date(&1))
    |> Map.update(:registration_date, params[:registration_date], &to_date(&1))
    |> Map.update(:renewal_date, params[:renewal_date], &to_date(&1))
  end

  defp to_json(params) do
    params
    |> Map.update(:case_file_statements, params[:case_file_statements], &Poison.encode!(&1))
    |> Map.update(:case_file_event_statements, params[:case_file_event_statements], &Poison.encode!(&1))
    |> Map.update(:correspondent, params[:correspondent], &Poison.encode!(&1))
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