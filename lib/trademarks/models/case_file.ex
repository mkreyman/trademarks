defmodule Trademarks.CaseFile do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Trademarks.{
    CaseFile,
    CaseFileOwner,
    Utils.ParamsFormatter,
    Repo
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_files" do
    field :serial_number, :string
    field :registration_number, :string
    field :filing_date, :date
    field :registration_date, :date
    field :mark_identification, :string
    field :renewal_date, :date
    field :attorney, :string
    field :case_file_statements, :string
    field :case_file_event_statements, :string
    field :correspondent, :string
    many_to_many :case_file_owners, CaseFileOwner, join_through: "case_files_case_file_owners", on_replace: :delete

    timestamps()
  end

  @fields ~w(serial_number
             registration_number
             filing_date
             registration_date
             mark_identification
             renewal_date
             attorney
             case_file_statements
             case_file_event_statements
             correspondent)a

  def changeset(struct, params \\ %{}) do
    params = ParamsFormatter.format(params)
    struct
    |> cast(params, @fields)
    |> validate_required([:serial_number])
    |> unique_constraint(:serial_number)
    |> validate_date_format(params)
    |> cast_assoc(:case_file_owners)
  end

  def process(stream) do
    started = :os.system_time(:seconds)
    number_of_case_files_before = Trademarks.Repo.one(from cf in "case_files", select: count(cf.id))
    number_of_case_file_owners_before = Trademarks.Repo.one(from cfo in "case_file_owners", select: count(cfo.id))
    Logger.info "Started processing ..."

    # subset = 30000
    stream
    # |> Stream.take(subset)
    |> Enum.map(&create(&1))

    finished = :os.system_time(:seconds)
    number_of_case_files_now = Trademarks.Repo.one(from cf in "case_files", select: count(cf.id))
    new_case_files = number_of_case_files_now - number_of_case_files_before
    number_of_case_file_owners_now = Trademarks.Repo.one(from cfo in "case_file_owners", select: count(cfo.id))
    new_case_file_owners = number_of_case_file_owners_now - number_of_case_file_owners_before
    Logger.info """
      There were #{number_of_case_files_before} existing case files and
      #{number_of_case_file_owners_before} case file owners. Processed #{new_case_files} new case files
      and #{new_case_file_owners} new case file owners in #{finished - started} secs\n
      """
  end

  def create(params) do
    cs = changeset(%CaseFile{}, params)
    Repo.insert(cs, on_conflict: update_owners(params), conflict_target: :serial_number)
  end

  def update_owners(params) do
    case_file = Repo.get_by(CaseFile, serial_number: params[:serial_number])
                |> Repo.preload(:case_file_owners)

    csmap = Enum.map(params[:case_file_owners], fn owner ->
              CaseFileOwner.changeset(CaseFileOwner, owner)
            end)

    Ecto.Changeset.change(case_file)
    |> Ecto.Changeset.put_assoc(:case_file_owners, csmap )
    |> Repo.update!
  end

  def parse_case_file_owners(params) do
    params[:case_file_owners]
    |> insert_and_get_all()
  end

  defp insert_and_get_all([]), do: []
  defp insert_and_get_all(owners) do
    party_names = Enum.map(owners, &(&1[:party_name]))
    maps = Enum.map(owners, &(&1))
    maps =
      maps
      |> Enum.map(fn row ->
           row
           |> Map.put(:inserted_at, DateTime.utc_now)
           |> Map.put(:updated_at, DateTime.utc_now)
         end)

    Repo.insert_all(CaseFileOwner, maps, on_conflict: :nothing)
    Repo.all(from cfo in CaseFileOwner, where: cfo.party_name in ^party_names)
  end

  defp validate_date_format(cs, params) do
    dates = [params[:filing_date],
             params[:registration_date],
             params[:renewal_date]]
    if Enum.any?(dates, fn(date)-> ParamsFormatter.is_date(date) end) == false do
      add_error(cs, :case_files, "case_file")
    else
      cs
    end
  end
end