defmodule Trademarks.CaseFile do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    ActionKey,
    CaseFileStatement,
    CaseFileEventStatement,
    CaseFileOwner,
    Correspondent
    }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_files" do
    belongs_to :action_key, ActionKey, type: :binary_id
    field :serial_number,       :string
    field :registration_number, :string
    field :filing_date,         :date
    field :registration_date,   :date
    field :mark_identification, :string
    field :attorney_name,       :string
    field :renewal_date,        :date
    has_many :case_file_statements, CaseFileStatement, on_delete: :delete_all
    has_many :case_file_event_statements, CaseFileEventStatement, on_delete: :delete_all
    has_many :case_file_owners, CaseFileOwner, on_delete: :delete_all
    has_one  :correspondent, Correspondent, on_delete: :delete_all

    timestamps
  end

  @fields ~w(serial_number
             registration_number
             filing_date
             registration_date
             mark_identification
             attorney_name
             renewal_date
            )

  def changeset(data, params \\ %{}) do
    params = format_dates(params)
    data
    |> cast(params, @fields)
    # |> validate_required([:mark_identification])
    # |> validate_date_format(params)
  end

  defp validate_date_format(cs, params) do
    dates = [
      params[:filing_date],
      params[:registration_date],
      params[:renewal_date]
    ]
    if Enum.any?(dates, fn(date)-> is_date(date) end) == false do
      add_error(cs, :case_files, "Invalid date format")
    else
      cs
    end
  end

  defp is_date(date) do
    try do
      %Date{} = date
      true
    rescue
      MatchError -> false
    end
  end

  defp format_dates(params) do
    params
    |> Map.update(:filing_date, params[:filing_date], &to_date(&1))
    |> Map.update(:registration_date, params[:registration_date], &to_date(&1))
    |> Map.update(:renewal_date, params[:renewal_date], &to_date(&1))
  end

  defp to_date(string) do
    if byte_size(string) == 0 do
      nil
    else
      ~r"(\d{4})(\d{2})(\d{2})"
      |> Regex.run(string)
      |> Enum.take(-3)
      |> Enum.join("-")
      |> Date.from_iso8601!()
    end
  end
end