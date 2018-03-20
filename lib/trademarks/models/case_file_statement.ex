defmodule Trademarks.CaseFileStatement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{CaseFileStatement, CaseFile, Repo}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_statements" do
    belongs_to(:case_file, CaseFile, type: :binary_id)
    field(:description, :string)
    field(:type_code, :string)

    timestamps()
  end

  @fields ~w(description type_code)

  @doc false
  def changeset(case_file_statement, attrs \\ %{}) do
    case_file_statement
    |> cast(attrs, @fields)
    |> foreign_key_constraint(:case_file_id, message: "Select a valid case file")
    |> unique_constraint(:case_file_id_type_code_description_index)
  end

  def create_or_update_all(attrs, case_file) do
    attrs
    |> Enum.map(&create_or_update(&1, case_file))
  end

  defp create_or_update(attrs, case_file) do
    case Repo.get_by(
           CaseFileStatement,
           case_file_id: case_file.id,
           description: attrs[:description],
           type_code: attrs[:type_code]
         ) do
      nil ->
        %CaseFileStatement{
          case_file_id: case_file.id,
          description: attrs[:description],
          type_code: attrs[:type_code]
        }

      case_file_statement ->
        case_file_statement
    end
    |> changeset(attrs)
    |> Repo.insert_or_update()
    |> case do
      {:ok, case_file_statement} -> case_file_statement
      {:error, changeset} -> {:error, changeset}
    end
  end
end
