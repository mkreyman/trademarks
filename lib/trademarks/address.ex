defmodule Trademarks.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "addresses" do
    belongs_to :case_file_owner, Trademarks.CaseFileOwner, type: :binary_id
    field :address_1, :string
    field :address_2, :string
    field :city,      :string
    field :state,     :string
    field :postcode,  :string

    timestamps
  end

  @fields ~w(address_1 address_2 city state postcode)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
  end
end