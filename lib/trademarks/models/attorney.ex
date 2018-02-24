defmodule Trademarks.Attorney do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{CaseFile, Attorney, Repo}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "attorneys" do
    field :name, :string
    has_many :case_files, CaseFile
    has_many :correspondents, through: [:case_files, :correspondent]
    has_many :case_file_owners, through: [:case_files, :case_file_owners]
    has_many :addresses, through: [:case_file_owners, :addresses]
    has_many :case_file_statements, through: [:case_files, :case_file_statements]
    has_many :case_file_event_statements, through: [:case_files, :case_file_event_statements]
    timestamps()
  end

  @fields ~w(name)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> unique_constraint(:name)
  end

  def create_or_update(%{attorney: nil}), do: nil
  def create_or_update(%{attorney: ""}), do: nil
  def create_or_update(params) do
    case Repo.get_by(Attorney, name: params[:attorney]) do
      nil  -> %Attorney{name: params[:attorney]}
      attorney -> attorney
    end
    |> changeset(params)
    |> Repo.insert_or_update
    |> case do
         {:ok, attorney}     -> attorney.id
         {:error, changeset} -> {:error, changeset}
       end
  end
end