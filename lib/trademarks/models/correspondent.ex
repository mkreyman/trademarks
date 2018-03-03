defmodule Trademarks.Correspondent do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{Correspondent, CaseFile, Repo}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "correspondents" do
    field(:address_1, :string)
    field(:address_2, :string)
    field(:address_3, :string)
    field(:address_4, :string)
    field(:address_5, :string)
    has_many(:case_files, CaseFile)
    timestamps()
  end

  @fields ~w(address_1 address_2 address_3 address_4 address_5)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> unique_constraint(:addresses_index)
  end

  def create_or_update(params) do
    case Repo.get_by(
           Correspondent,
           address_1: params[:address_1],
           address_2: params[:address_2],
           address_3: params[:address_3],
           address_4: params[:address_4],
           address_5: params[:address_5]
         ) do
      nil ->
        %Correspondent{
          address_1: params[:address_1],
          address_2: params[:address_2],
          address_3: params[:address_3],
          address_4: params[:address_4],
          address_5: params[:address_5]
        }

      correspondent ->
        correspondent
    end
    |> changeset(params)
    |> Repo.insert_or_update()
    |> case do
      {:ok, correspondent} -> correspondent.id
      {:error, changeset} -> {:error, changeset}
    end
  end
end
