defmodule Trademarks.CaseFileEventStatement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{CaseFile, Utils.DateFormatter}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_event_statements" do
    belongs_to :case_file, CaseFile, type: :binary_id
    field :code,        :string
    field :type,        :string
    field :description, :string
    field :date,        :date

    timestamps()
  end

  @fields ~w(code type description date)

  def changeset(data, params \\ %{}) do
    params = DateFormatter.format(params)
    data
    |> cast(params, @fields)
    |> foreign_key_constraint(:case_file_id, message: "Select a valid case file")
    |> validate_date_format(params)
  end

  defp validate_date_format(cs, params) do
    if DateFormatter.is_date(params[:date]) == false do
      add_error(cs, :case_file_event_statements, "Invalid date format")
    else
      cs
    end
  end
end