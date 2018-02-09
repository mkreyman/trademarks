defmodule Trademarks.CaseFile do
  require Logger
  require IEx
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Trademarks.{
    CaseFile,
    CaseFileOwner,
    CaseFilesCaseFileOwner,
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
    many_to_many :case_file_owners, CaseFileOwner, join_through: CaseFilesCaseFileOwner, on_replace: :delete

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
  end

  def process(stream) do
    started = :os.system_time(:seconds)
    number_of_case_files_before = Trademarks.Repo.one(from cf in "case_files", select: count(cf.id))
    number_of_case_file_owners_before = Trademarks.Repo.one(from cfo in "case_file_owners", select: count(cfo.id))
    Logger.info "Started processing ..."

    # subset = 3
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
    case_file =
      case Repo.get_by(CaseFile, serial_number: params[:serial_number]) do
        nil  -> %CaseFile{serial_number: params[:serial_number]}
        case_file -> case_file
      end
      |> CaseFile.changeset(params)
      |> Repo.insert_or_update
      |> case do
           {:ok, case_file}    -> case_file
           {:error, changeset} -> {:error, changeset}
         end

    # case_file_changeset = changeset(%CaseFile{}, params)
    # on_conflict = [set: [body: "updated"]]
    # {:ok, case_file} = Repo.insert(case_file_changeset,
    #                      on_conflict: :replace_all, conflict_target: :serial_number)

    # {:ok, case_file} = Repo.insert_or_update(case_file_changeset)

    params[:case_file_owners]
    |> Enum.map(&(CaseFileOwner.changeset(%CaseFileOwner{}, &1)))
    |> Enum.map(&(Repo.insert(&1, on_conflict: :replace_all, conflict_target: :party_name)))
    |> Enum.map(fn({:ok, owner}) -> owner end)
    |> Enum.map(fn(case_file_owner) ->
         cs = CaseFilesCaseFileOwner.changeset(
                %CaseFilesCaseFileOwner{}, %{case_file_id: case_file.id,
                                             case_file_owner_id: case_file_owner.id}
              )
         Repo.insert(cs, on_conflict: :nothing)
         # case Repo.insert(cs) do
         #   {:ok, assoc} -> # Assoc was created!
         #   {:error, changeset} -> # Handle the error
         # end
       end)
  end

  # def update_owners(params) do
  #   owners = Enum.map(params[:case_file_owners], &(parse_case_file_owners/1))
  #   IEx.pry
  #   case_file = find_or_create(params)
  #               |> Repo.preload(:case_file_owners)
  #               |> Ecto.Changeset.change()
  #               |> Ecto.Changeset.put_assoc(:case_file_owners, Enum.map(owners, &change/1))
  #               |> Repo.update!
  # end

  # def find_or_create(case_file_params) do
  #   query = (from cf in CaseFile,
  #            where: cf.serial_number == ^case_file_params[:serial_number])
  #   if !Repo.one(query)  do
  #     Repo.insert(CaseFile.changeset(%CaseFile{}, case_file_params))
  #   end
  #   Repo.one(query)
  # end

  # def parse_case_file_owners(params) do
  #   params[:case_file_owners]
  #   |> insert_and_get_all()
  # end

  # defp insert_and_get_all([]), do: []
  # defp insert_and_get_all(owners) do
  #   party_names = Enum.map(owners, &(&1[:party_name]))
  #   maps = Enum.map(owners, &(&1))
  #   maps =
  #     maps
  #     |> Enum.map(fn row ->
  #          row
  #          |> Map.put(:inserted_at, DateTime.utc_now)
  #          |> Map.put(:updated_at, DateTime.utc_now)
  #        end)

  #   Repo.insert_all(CaseFileOwner, maps, on_conflict: :nothing)
  #   Repo.all(from cfo in CaseFileOwner, where: cfo.party_name in ^party_names)
  # end

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