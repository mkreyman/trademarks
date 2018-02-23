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
    field :dba, :string
    field :nationality_country, :string
    field :nationality_state, :string
    field :party_name, :string
    field :address_1, :string
    field :address_2, :string
    field :city, :string
    field :state, :string
    field :postcode, :string
    field :country, :string
    many_to_many :case_files, CaseFile, join_through: CaseFilesCaseFileOwner, on_replace: :delete
    has_many :attorneys, through: [:case_files, :attorney]
    has_many :correspondents, through: [:case_files, :correspondent]
    has_many :case_file_statements, through: [:case_files, :case_file_statements]
    has_many :case_file_event_statements, through: [:case_files, :case_file_event_statements]
    has_many :linked, through: [:case_files, :case_file_owners]
    timestamps()
  end

  @fields ~w(dba
             nationality_country
             nationality_state
             party_name
             address_1
             address_2
             city
             state
             postcode
             country)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> unique_constraint(:nationality_state_party_name_index)
  end

  def create_or_update(params) do
    case Repo.get_by(CaseFileOwner, party_name: params[:party_name],
                                    nationality_state: params[:nationality_state]) do
      nil  -> %CaseFileOwner{party_name: params[:party_name],
                             nationality_state: params[:nationality_state]}
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