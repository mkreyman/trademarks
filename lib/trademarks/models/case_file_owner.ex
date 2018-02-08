defmodule Trademarks.CaseFileOwner do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{CaseFileOwner, CaseFile, Repo}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_owners" do
    field :party_name, :string
    field :address_1, :string
    field :address_2, :string
    field :city, :string
    field :state, :string
    field :postcode, :string
    many_to_many :case_files, CaseFile, join_through: "case_files_case_file_owners", on_replace: :delete

    timestamps()
  end

  @fields ~w(party_name address_1 address_2 city state postcode)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> unique_constraint(:party_name, name: :case_file_owners_party_name_address_1_city_state_postcode_index)
  end

  def create(params) do
    cs = changeset(%CaseFileOwner{}, params)
    Repo.insert(cs, on_conflict: :nothing)
    # case cs.valid? do
    #   true ->
    #     Repo.insert(cs, on_conflict: :nothing)
    #   _ ->
    #     Logger.error "Given params: #{Poison.encode!(params)}"
    #     add_error(cs, :case_file_owners, "case_file_owner")
    # end
  end
end