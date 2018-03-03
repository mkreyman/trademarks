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

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> foreign_key_constraint(:case_file_id, message: "Select a valid case file")
    |> unique_constraint(:case_file_id_type_code_description_index)
  end

  def create_or_update_all(params, case_file) do
    params
    |> Enum.map(&create_or_update(&1, case_file))
  end

  defp create_or_update(params, case_file) do
    case Repo.get_by(
           CaseFileStatement,
           case_file_id: case_file.id,
           description: params[:description],
           type_code: params[:type_code]
         ) do
      nil ->
        %CaseFileStatement{
          case_file_id: case_file.id,
          description: params[:description],
          type_code: params[:type_code]
        }

      case_file_statement ->
        case_file_statement
    end
    |> changeset(params)
    |> Repo.insert_or_update()
    |> case do
      {:ok, case_file_statement} -> case_file_statement
      {:error, changeset} -> {:error, changeset}
    end
  end
end
