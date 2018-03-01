defmodule Trademarks.Trademark do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    Trademark,
    CaseFile,
    CaseFileOwnersTrademark,
    CaseFileOwner,
    Repo
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "trademarks" do
    field :name, :string
    has_many :case_files, CaseFile, on_replace: :delete
    many_to_many :case_file_owners, CaseFileOwner, join_through: CaseFileOwnersTrademark, on_replace: :delete
    timestamps()
  end

  @fields ~w(name)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> unique_constraint(:name)
  end

  def create_or_update(%{trademark_name: ""}) do
    {:ok, nil}
  end
  def create_or_update(params) do
    case Repo.get_by(Trademark, name: params[:trademark_name]) do
      nil  -> %Trademark{name: params[:trademark_name]}
      trademark -> trademark
    end
    |> changeset(params)
    |> Repo.insert_or_update
    |> case do
         {:ok, trademark}    -> {:ok, trademark.id}
         {:error, changeset} -> {:error, changeset}
       end
  end
end