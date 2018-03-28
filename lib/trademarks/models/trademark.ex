defmodule Trademarks.Trademark do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    Trademark,
    CaseFile,
    CaseFileOwnersTrademark,
    CaseFileOwner,
    Repo,
    Utils.AttrsFormatter
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "trademarks" do
    field(:name, :string)
    has_many(:case_files, CaseFile, on_replace: :delete)

    many_to_many(
      :case_file_owners,
      CaseFileOwner,
      join_through: CaseFileOwnersTrademark,
      on_replace: :delete
    )

    has_many(:trademarks, through: [:case_file_owners, :trademarks])

    timestamps()
  end

  @fields ~w(name)a

  @doc false
  def changeset(trademark, attrs \\ %{}) do
    attrs = AttrsFormatter.format(attrs)

    trademark
    |> cast(attrs, @fields)
    |> unique_constraint(:name)
  end

  def create_or_update(%{trademark_name: ""}) do
    {:ok, nil}
  end

  def create_or_update(attrs) do
    attrs = AttrsFormatter.format(attrs)

    case Repo.get_by(Trademark, name: attrs[:trademark_name]) do
      nil -> %Trademark{name: attrs[:trademark_name]}
      trademark -> trademark
    end
    |> changeset(attrs)
    |> Repo.insert_or_update()
    |> case do
      {:ok, trademark} -> {:ok, trademark.id}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
