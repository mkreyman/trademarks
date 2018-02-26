defmodule Trademarks.Address do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    Address,
    CaseFileOwnersAddress,
    CaseFileOwner,
    Repo
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "addresses" do
    field :address_1, :string
    field :address_2, :string
    field :city, :string
    field :state, :string
    field :postcode, :string
    field :country, :string
    many_to_many :case_file_owners, CaseFileOwner, join_through: CaseFileOwnersAddress, on_replace: :delete
    # has_many :linked, through: [:case_file_owners, :addresses]
    timestamps()
  end

  @fields ~w(address_1
             address_2
             city
             state
             postcode
             country)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> unique_constraint(:address_1_postcode_index)
  end

  def create_or_update(params) do
    case Repo.get_by(Address, address_1: params[:address_1],
                              postcode: params[:postcode]) do
      nil  -> %Address{address_1: params[:address_1],
                       postcode: params[:postcode]}
      address -> address
    end
    |> changeset(params)
    |> Repo.insert_or_update
    |> case do
         {:ok, address}      -> {:ok, address}
         {:error, changeset} -> {:error, changeset}
       end
  end
end