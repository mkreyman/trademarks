defmodule Trademarks.CaseFileOwner do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.CaseFile

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_owners" do
    belongs_to :case_file, CaseFile, type: :binary_id
    field :party_name, :string
    field :address_1, :string
    field :address_2, :string
    field :city, :string
    field :state, :string
    field :postcode, :string

    timestamps()
  end

  @fields ~w(party_name address_1 address_2 city state postcode)

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> foreign_key_constraint(:case_file_id, message: "Select a valid case file")
  end
end