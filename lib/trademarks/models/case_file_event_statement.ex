defmodule Trademarks.CaseFileEventStatement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    CaseFileEventStatement,
    CaseFile,
    Repo,
    Utils.ParamsFormatter
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_file_event_statements" do
    belongs_to :case_file, CaseFile, type: :binary_id
    field :code,        :string
    field :date,        :date
    field :description, :string
    field :type,        :string
    timestamps()
  end

  @fields ~w(code date description type)

  def changeset(struct, params \\ %{}) do
    params = ParamsFormatter.format(params)
    struct
    |> cast(params, @fields)
    |> foreign_key_constraint(:case_file_id, message: "Select a valid case file")
    |> unique_constraint(:case_file_id_code_type_description_date_index)
    |> validate_date_format(params)
  end

  def create_or_update_all(params, case_file) do
    params
    |> Enum.map(&create_or_update(&1, case_file))
  end

  defp create_or_update(params, case_file) do
    params = ParamsFormatter.format(params)
    case Repo.get_by(CaseFileEventStatement, case_file_id: case_file.id,
                                             code: params[:code],
                                             date: params[:date],
                                             description: params[:description],
                                             type: params[:type]) do
      nil  -> %CaseFileEventStatement{case_file_id: case_file.id,
                                      code: params[:code],
                                      date: params[:date],
                                      description: params[:description],
                                      type: params[:type]}
      case_file_event_statement -> case_file_event_statement
    end
    |> changeset(params)
    |> Repo.insert_or_update
    |> case do
         {:ok, case_file_event_statement} -> case_file_event_statement
         {:error, changeset}    -> {:error, changeset}
       end
  end

  defp validate_date_format(cs, params) do
    if ParamsFormatter.is_date(params[:date]) == false do
      add_error(cs, :case_file_event_statements, "case_file_event_statement")
    else
      cs
    end
  end
end