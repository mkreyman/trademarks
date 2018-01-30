defmodule Trademarks.CaseFileEventStatement do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_event_statements" do
    belongs_to :case_file, Trademarks.CaseFile, type: :binary_id
    field :code,        :string
    field :type,        :string
    field :description, :string
    field :date,        :date

    timestamps
  end

  @fields ~w(code type description date)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> foreign_key_constraint(:case_file_id, message: "Select a valid case file")
  end
end