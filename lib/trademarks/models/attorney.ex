defmodule Trademarks.Attorney do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Trademarks.{CaseFile, Attorney, Repo}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "attorneys" do
    field :name, :string
    has_many :case_files, CaseFile
    timestamps()
  end

  @fields ~w(name)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> unique_constraint(:name)
  end

  def create_or_update(%{attorney: nil}), do: nil
  def create_or_update(params) do
    case Repo.get_by(Attorney, name: params[:attorney]) do
      nil  -> %Attorney{name: params[:attorney]}
      attorney -> attorney
    end
    |> changeset(params)
    |> Repo.insert_or_update
    |> case do
         {:ok, attorney} -> attorney.id
         {:error, changeset}    -> {:error, changeset}
       end
  end

  def find(queryable \\ __MODULE__, params) do
    term = params[:attorney_name]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    queryable
    |> where([a], ilike(a.name, ^query))
    |> preload(:case_files)
    |> Repo.all
  end
end