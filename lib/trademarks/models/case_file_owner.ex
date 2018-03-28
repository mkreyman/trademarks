defmodule Trademarks.CaseFileOwner do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    CaseFilesCaseFileOwner,
    CaseFileOwner,
    CaseFile,
    Trademark,
    CaseFileOwnersTrademark,
    Repo,
    Utils.AttrsFormatter
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_owners" do
    field(:dba, :string)
    field(:nationality_country, :string)
    field(:nationality_state, :string)
    field(:name, :string)
    field(:address_1, :string)
    field(:address_2, :string)
    field(:city, :string)
    field(:state, :string)
    field(:postcode, :string)
    field(:country, :string)
    many_to_many(:case_files, CaseFile, join_through: CaseFilesCaseFileOwner, on_replace: :delete)

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
             name
             address_1
             address_2
             city
             state
             postcode
             country)a

  @doc false
  def changeset(case_file_owner, attrs \\ %{}) do
    attrs = AttrsFormatter.format(attrs)

    case_file_owner
    |> cast(attrs, @fields)
    |> unique_constraint(:name)
  end

  def create_or_update(attrs) do
    attrs = AttrsFormatter.format(attrs)

    case Repo.get_by(CaseFileOwner, name: attrs[:name]) do
      nil ->
        %CaseFileOwner{name: attrs[:name]}

      case_file_owner ->
        case_file_owner
    end
    |> changeset(attrs)
    |> Repo.insert_or_update()
    |> case do
      {:ok, case_file_owner} -> {:ok, case_file_owner}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
