defmodule Trademarks.CaseFileOwner do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Trademarks.{CaseFilesCaseFileOwner, CaseFileOwner, CaseFile, Repo}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_owners" do
    field :party_name, :string
    field :address_1, :string
    field :address_2, :string
    field :city, :string
    field :state, :string
    field :postcode, :string
    many_to_many :case_files, CaseFile, join_through: CaseFilesCaseFileOwner, on_replace: :delete

    timestamps()
  end

  @fields ~w(party_name address_1 address_2 city state postcode)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> unique_constraint(:party_name)
  end

  def create(params) do
    cs = changeset(%CaseFileOwner{}, params)
    Repo.insert(cs, on_conflict: :nothing)
    # case cs.valid? do
    #   true ->
    #     Repo.insert(cs, on_conflict: :nothing)
    #   _ ->
    #     Logger.error fn ->
    #       "Given params: #{Poison.encode!(params)}"
    #     end
    #     add_error(cs, :case_file_owners, "case_file_owner")
    # end
  end

  def find(queryable \\ __MODULE__, params) do
    term = params[:party_name]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    queryable
    |> where([o], ilike(o.party_name, ^query))
    |> preload(:case_files)
  end
end