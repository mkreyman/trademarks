defmodule Trademarks.CaseFileOwner do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    Address,
    CaseFileOwnersAddress,
    CaseFilesCaseFileOwner,
    CaseFileOwner,
    CaseFile,
    Trademark,
    CaseFileOwnersTrademark,
    Repo
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_owners" do
    field(:dba, :string)
    field(:nationality_country, :string)
    field(:nationality_state, :string)
    field(:party_name, :string)
    many_to_many(:case_files, CaseFile, join_through: CaseFilesCaseFileOwner, on_replace: :delete)
    many_to_many(:addresses, Address, join_through: CaseFileOwnersAddress, on_replace: :delete)

    many_to_many(
      :trademarks,
      Trademark,
      join_through: CaseFileOwnersTrademark,
      on_replace: :delete
    )

    timestamps()
  end

  @fields ~w(dba
             nationality_country
             nationality_state
             party_name)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> unique_constraint(:nationality_state_party_name_index)
  end

  def create_or_update(params) do
    case Repo.get_by(
           CaseFileOwner,
           party_name: params[:party_name],
           nationality_state: params[:nationality_state]
         ) do
      nil ->
        %CaseFileOwner{
          party_name: params[:party_name],
          nationality_state: params[:nationality_state]
        }

      case_file_owner ->
        case_file_owner
    end
    |> changeset(params)
    |> Repo.insert_or_update()
    |> case do
      {:ok, case_file_owner} ->
        case_file_owner
        |> associate_address(params)

        {:ok, case_file_owner}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp associate_address(case_file_owner, params) do
    address_params = %{
      address_1: params[:address_1],
      address_2: params[:address_2],
      city: params[:city],
      state: params[:state],
      postcode: params[:postcode],
      country: params[:country]
    }

    with {:ok, address} <- Address.create_or_update(address_params) do
      %CaseFileOwnersAddress{}
      |> CaseFileOwnersAddress.changeset(%{
        case_file_owner_id: case_file_owner.id,
        address_id: address.id
      })
      |> Repo.insert(on_conflict: :nothing)

      case_file_owner
    else
      _ ->
        Logger.error(fn ->
          "Something went wrong with params: #{inspect(params)}"
        end)

        case_file_owner
    end
  end
end
