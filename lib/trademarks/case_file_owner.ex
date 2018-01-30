defmodule Trademarks.CaseFileOwner do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_owners" do
    belongs_to :case_file, Trademarks.CaseFile, type: :binary_id
    field :party_name, :string
    has_many :addresses, Trademarks.Address

    timestamps
  end

  @fields ~w(party_name)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:party_name])
  end
end