defmodule Trademarks.CaseFileStatement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.CaseFile

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_statements" do
    belongs_to :case_file, CaseFile, type: :binary_id
    field :type_code,   :string
    field :description, :string

    timestamps()
  end

  @fields ~w(type_code description)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> foreign_key_constraint(:case_file_id, message: "Select a valid case file")
    |> unique_constraint(:description, name: :case_file_statements_type_code_description_index)
  end
end