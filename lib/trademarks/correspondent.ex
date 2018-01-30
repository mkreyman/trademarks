defmodule Trademarks.Correspondent do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "correspondents" do
    belongs_to :case_file, Trademarks.CaseFile, type: :binary_id
    field :address_1, :string
    field :address_2, :string
    field :address_3, :string
    field :address_4, :string

    timestamps
  end

  @fields ~w(address_1 address_2 address_3 address_4)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
  end
end