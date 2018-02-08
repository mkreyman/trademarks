defmodule Trademarks.CaseFile do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Trademarks.{
    CaseFile,
    Attorney,
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
    field :renewal_date,        :date
    many_to_many :attorneys, Attorney, join_through: "case_files_attorneys", on_replace: :delete
    has_many :case_file_statements, CaseFileStatement, on_replace: :nilify
    has_many :case_file_event_statements, CaseFileEventStatement, on_replace: :nilify
    has_many :case_file_owners, CaseFileOwner, on_replace: :nilify
    has_one  :correspondent, Correspondent, on_replace: :nilify

    timestamps()
  end

  @fields ~w(serial_number
             registration_number
             filing_date
             registration_date
             mark_identification
             renewal_date)a

  def changeset(struct, params \\ %{}) do
    params = DateFormatter.format(params)
    struct
    |> cast(params, @fields)
    |> validate_required([:serial_number])
    |> unique_constraint(:serial_number)
    |> validate_date_format(params)
    |> cast_assoc(:attorneys)
    |> cast_assoc(:case_file_statements)
    |> cast_assoc(:case_file_event_statements)
    |> cast_assoc(:case_file_owners)
    |> cast_assoc(:correspondent)
  end

  def process(stream) do
    started = :os.system_time(:seconds)
    number_of_records_before = Trademarks.Repo.one(from cf in "case_files", select: count(cf.id))
    Logger.info "Started processing ..."

    # subset = 30000
    stream
    # |> Stream.take(subset)
    |> Enum.map(&create(&1))

    finished = :os.system_time(:seconds)
    number_of_records_now = Trademarks.Repo.one(from cf in "case_files", select: count(cf.id))
    number_of_records = number_of_records_now - number_of_records_before
    Logger.info "Processed #{number_of_records} case files in #{finished - started} secs"
  end

  def create(params) do
    cs = changeset(%CaseFile{}, params)
    case cs.valid? do
      true ->
        Repo.insert(cs)
      _ ->
        Logger.error "Invalid changeset: #{Poison.encode!(params)}"
    end
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
end