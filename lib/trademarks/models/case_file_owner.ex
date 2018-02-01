defmodule Trademarks.CaseFileOwner do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.CaseFile

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_owners" do
    belongs_to :case_file, CaseFile, type: :binary_id
    field :party_name, :string
    field :address_1, :string
    field :city, :string
    field :state, :string
    field :postcode, :string

    timestamps()
  end

  @fields ~w(party_name address_1 city state postcode)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:party_name])
    |> foreign_key_constraint(:case_file_id, message: "Select a valid case file")
  end
end