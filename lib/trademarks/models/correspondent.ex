defmodule Trademarks.Correspondent do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    Correspondent,
    CaseFile,
    Repo,
    Utils.AttrsFormatter
  }

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

  @doc false
  def changeset(correspondent, attrs \\ %{}) do
    attrs = AttrsFormatter.format(attrs)

    correspondent
    |> cast(attrs, @fields)
    |> unique_constraint(:address_1)
  end

  def create_or_update(attrs) do
    attrs = AttrsFormatter.format(attrs)

    case Repo.get_by(Correspondent, address_1: attrs[:address_1]) do
      nil -> %Correspondent{address_1: attrs[:address_1]}
      correspondent -> correspondent
    end
    |> changeset(attrs)
    |> Repo.insert_or_update()
    |> case do
      {:ok, correspondent} -> correspondent.id
      {:error, changeset} -> {:error, changeset}
    end
  end
end
