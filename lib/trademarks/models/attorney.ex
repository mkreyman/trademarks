defmodule Trademarks.Attorney do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.CaseFile

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "attorneys" do
    field :name, :string
    many_to_many :case_files, CaseFile, join_through: "case_files_attorneys"

    timestamps()
  end

  @fields ~w(name)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> unique_constraint(:name)
  end
end