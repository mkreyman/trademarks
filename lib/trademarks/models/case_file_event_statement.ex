defmodule Trademarks.CaseFileEventStatement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    CaseFileEventStatement,
    CaseFile,
    Repo,
    Utils.AttrsFormatter
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_event_statements" do
    belongs_to(:case_file, CaseFile, type: :binary_id)
    field(:code, :string)
    field(:date, :date)
    field(:description, :string)
    field(:event_type, :string)

    timestamps()
  end

  @fields ~w(code date description event_type)

  @doc false
  def changeset(case_file_event_statement, attrs \\ %{}) do
    attrs = AttrsFormatter.format(attrs)

    case_file_event_statement
    |> cast(attrs, @fields)
    |> foreign_key_constraint(:case_file_id, message: "Select a valid case file")
    |> unique_constraint(:case_file_id_code_type_description_date_index)
    |> validate_date_format(attrs)
  end

  def create_or_update_all(attrs, case_file) do
    attrs
    |> Enum.map(&create_or_update(&1, case_file))
  end

  defp create_or_update(attrs, case_file) do
    attrs = AttrsFormatter.format(attrs)

    case Repo.get_by(
           CaseFileEventStatement,
           case_file_id: case_file.id,
           code: attrs[:code],
           date: attrs[:date],
           description: attrs[:description],
           event_type: attrs[:event_type]
         ) do
      nil ->
        %CaseFileEventStatement{
          case_file_id: case_file.id,
          code: attrs[:code],
          date: attrs[:date],
          description: attrs[:description],
          event_type: attrs[:event_type]
        }

      case_file_event_statement ->
        case_file_event_statement
    end
    |> changeset(attrs)
    |> Repo.insert_or_update()
    |> case do
      {:ok, case_file_event_statement} -> case_file_event_statement
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp validate_date_format(cs, attrs) do
    if AttrsFormatter.is_date(attrs[:date]) == false do
      add_error(cs, :case_file_event_statements, "case_file_event_statement")
    else
      cs
    end
  end
end
