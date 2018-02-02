defmodule Trademarks.Correspondent do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.CaseFile

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "correspondents" do
    belongs_to :case_file, CaseFile, type: :binary_id
    field :address_1, :string
    field :address_2, :string
    field :address_3, :string
    field :address_4, :string

    timestamps()
  end

  @fields ~w(address_1 address_2 address_3 address_4)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> foreign_key_constraint(:case_file_id, message: "Select a valid case file")
    |> validate_all()
  end

  defp validate_all(cs) do
    if cs.valid? == false do
      add_error(cs, :correspondents, "Invalid correspondent")
    else
      cs
    end
  end
end