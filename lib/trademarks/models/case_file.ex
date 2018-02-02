defmodule Trademarks.CaseFile do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    CaseFile,
    CaseFileStatement,
    CaseFileEventStatement,
    CaseFileOwner,
    Correspondent,
    Utils.DateFormatter,
    Repo
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_files" do
    field :serial_number,       :string
    field :registration_number, :string
    field :filing_date,         :date
    field :registration_date,   :date
    field :mark_identification, :string
    field :attorney_name,       :string
    field :renewal_date,        :date
    has_many :case_file_statements, CaseFileStatement, on_delete: :delete_all
    has_many :case_file_event_statements, CaseFileEventStatement, on_delete: :delete_all
    has_many :case_file_owners, CaseFileOwner, on_delete: :delete_all
    has_one  :correspondent, Correspondent, on_delete: :delete_all

    timestamps()
  end

  @fields ~w(serial_number
             registration_number
             filing_date
             registration_date
             mark_identification
             attorney_name
             renewal_date
            )

  def changeset(data, params \\ %{}) do
    params = DateFormatter.format(params)
    data
    |> cast(params, @fields)
    |> validate_date_format(params)
    |> cast_assoc(:case_file_statements)
    |> cast_assoc(:case_file_event_statements)
    |> cast_assoc(:case_file_owners)
    |> cast_assoc(:correspondent)
    |> validate_all()
  end

  def process(stream) do
    stream
    |> Enum.map(&create(&1))
  end

  def create(params) do
    changeset(%CaseFile{}, params)
    |> Repo.insert_or_update()
  end

  defp validate_date_format(cs, params) do
    dates = [
      params[:filing_date],
      params[:registration_date],
      params[:renewal_date]
    ]
    if Enum.any?(dates, fn(date)-> DateFormatter.is_date(date) end) == false do
      add_error(cs, :case_files, "case_file")
    else
      cs
    end
  end

  defp validate_all(cs) do
    if cs.valid? == false do
      add_error(cs, :case_files, "Invalid changeset: #{IO.inspect(cs.errors)}")
    else
      cs
    end
  end
end