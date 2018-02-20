defmodule Trademarks.CaseFileOwner do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    CaseFilesCaseFileOwner,
    CaseFileOwner,
    CaseFile,
    Repo
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_owners" do
    field :party_name, :string
    field :address_1, :string
    field :address_2, :string
    field :city, :string
    field :state, :string
    field :postcode, :string
    many_to_many :case_files, CaseFile, join_through: CaseFilesCaseFileOwner, on_replace: :delete
    has_one :attorney, through: [:case_files, :attorney]
    has_one :correspondent, through: [:case_files, :correspondent]
  end

  @fields ~w(party_name address_1 address_2 city state postcode)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> unique_constraint(:all_fields_index)
  end

  def create_or_update(params) do
    case Repo.get_by(CaseFileOwner, party_name: params[:party_name]) do
      nil  -> %CaseFileOwner{party_name: params[:party_name]}
      case_file_owner -> case_file_owner
    end
    |> changeset(params)
    |> Repo.insert_or_update
    |> case do
         {:ok, case_file_owner} -> {:ok, case_file_owner}
         {:error, changeset}    -> {:error, changeset}
       end
  end
end