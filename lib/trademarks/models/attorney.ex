defmodule Trademarks.Attorney do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "attorneys" do
    belongs_to :case_file, Trademarks.CaseFile, type: :binary_id
    field :name, :string
    timestamps()
  end

  @fields ~w(name)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> foreign_key_constraint(:case_file_id, message: "Select a valid case file")
    |> unique_constraint(:name)
  end
end