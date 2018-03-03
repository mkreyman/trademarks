defmodule Trademarks.CaseFile do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    Attorney,
    CaseFile,
    Trademark,
    CaseFileStatement,
    CaseFileEventStatement,
    Correspondent,
    CaseFileOwner,
    CaseFilesCaseFileOwner,
    Utils.ParamsFormatter,
    Repo
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_files" do
    field(:abandonment_date, :date)
    field(:filing_date, :date)
    field(:registration_date, :date)
    field(:registration_number, :string)
    field(:renewal_date, :date)
    field(:serial_number, :string)
    field(:status_date, :date)

    many_to_many(
      :case_file_owners,
      CaseFileOwner,
      join_through: CaseFilesCaseFileOwner,
      on_replace: :delete
    )

    belongs_to(:attorney, Attorney, type: :binary_id)
    belongs_to(:correspondent, Correspondent, type: :binary_id)
    belongs_to(:trademark, Trademark, type: :binary_id)
    has_many(:case_file_statements, CaseFileStatement, on_replace: :delete)
    has_many(:case_file_event_statements, CaseFileEventStatement, on_replace: :delete)
    timestamps()
  end

  @fields ~w(abandonment_date
             filing_date
             registration_date
             registration_number
             renewal_date
             serial_number
             status_date)a

  def changeset(struct, params \\ %{}) do
    params = ParamsFormatter.format(params)

    struct
    |> cast(params, @fields)
    |> unique_constraint(:serial_number)
    |> validate_date_format(params)
  end

  def create_or_update(params) do
    case Repo.get_by(CaseFile, serial_number: params[:serial_number]) do
      nil -> %CaseFile{serial_number: params[:serial_number]}
      case_file -> case_file
    end
    |> CaseFile.changeset(params)
    |> Repo.insert_or_update()
    |> case do
      {:ok, case_file} -> {:ok, case_file}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp validate_date_format(cs, params) do
    dates = [
      params[:abandonment_date],
      params[:filing_date],
      params[:registration_date],
      params[:renewal_date],
      params[:status_date],
      params[:date]
    ]

    if Enum.any?(dates, fn date -> ParamsFormatter.is_date(date) end) == false do
      add_error(cs, :case_files, "case_file")
    else
      cs
    end
  end
end
