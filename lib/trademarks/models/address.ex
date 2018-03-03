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
    field(:address_1, :string)
    field(:address_2, :string)
    field(:city, :string)
    field(:state, :string)
    field(:postcode, :string)
    field(:country, :string)

    many_to_many(
      :case_file_owners,
      CaseFileOwner,
      join_through: CaseFileOwnersAddress,
      on_replace: :delete
    )

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
    |> validate_at_least_one_field_present(params)
    |> unique_constraint(:addresses_address_1_address_2_city_index)
  end

  def create_or_update(params) do
    case Repo.get_by(
           Address,
           address_1: params[:address_1],
           address_2: params[:address_2],
           city: params[:city]
         ) do
      nil ->
        %Address{
          address_1: params[:address_1],
          address_2: params[:address_2],
          city: params[:city]
        }

      address ->
        address
    end
    |> changeset(params)
    |> Repo.insert_or_update()
    |> case do
      {:ok, address} -> {:ok, address}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def validate_at_least_one_field_present(cs, %{
        address_1: address_1,
        address_2: address_2,
        city: city,
        state: state,
        postcode: postcode,
        country: country
      }) do
    fields = [address_1, address_2, city, state, postcode, country]

    if Enum.any?(fields, fn field -> byte_size(field) > 0 end) == false do
      add_error(cs, :addresses, "address")
    else
      cs
    end
  end
end
