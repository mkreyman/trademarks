defmodule Trademarks.Attorney do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{CaseFile, Attorney, Repo}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "attorneys" do
    field(:name, :string)
    has_many(:case_files, CaseFile)

    timestamps()
  end

  @fields ~w(name)

  @doc false
  def changeset(attorney, attrs \\ %{}) do
    attorney
    |> cast(attrs, @fields)
    |> unique_constraint(:name)
  end

  def create_or_update(%{attorney: nil}), do: nil
  def create_or_update(%{attorney: ""}), do: nil

  def create_or_update(attrs) do
    case Repo.get_by(Attorney, name: attrs[:attorney]) do
      nil -> %Attorney{name: attrs[:attorney]}
      attorney -> attorney
    end
    |> changeset(attrs)
    |> Repo.insert_or_update()
    |> case do
      {:ok, attorney} -> attorney.id
      {:error, changeset} -> {:error, changeset}
    end
  end
end
