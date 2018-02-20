defmodule Trademarks.CaseFile do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Trademarks.{
    Attorney,
    CaseFile,
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
    belongs_to :attorney, Attorney, type: :binary_id
    belongs_to :correspondent, Correspondent, type: :binary_id
    field :serial_number, :string
    field :registration_number, :string
    field :filing_date, :date
    field :registration_date, :date
    field :trademark, :string
    field :renewal_date, :date
    has_many :case_file_statements, CaseFileStatement, on_delete: :delete_all
    has_many :case_file_event_statements, CaseFileEventStatement, on_delete: :delete_all
    many_to_many :case_file_owners, CaseFileOwner, join_through: CaseFilesCaseFileOwner, on_replace: :delete

    timestamps()
  end

  @fields ~w(serial_number
             registration_number
             filing_date
             registration_date
             trademark
             renewal_date)a

  def changeset(struct, params \\ %{}) do
    params = ParamsFormatter.format(params)
    struct
    |> cast(params, @fields)
    |> validate_required([:serial_number])
    |> unique_constraint(:case_files_serial_number_index)
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
    Logger.info fn ->
      """
      There were #{number_of_case_files_before} existing case files and
      #{number_of_case_file_owners_before} case file owners. Processed #{new_case_files} new case files
      and #{new_case_file_owners} new case file owners in #{finished - started} secs\n
      """
    end
  end

  def find(queryable \\ __MODULE__, params) do
    term = params[:trademark]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    queryable
    |> where([cf], ilike(cf.trademark, ^query))
    |> order_by(desc: :filing_date)
    |> preload(:attorney)
    |> preload(:case_file_statements)
    |> preload(:case_file_event_statements)
    |> preload(:correspondent)
    |> preload(:case_file_owners)
    |> Repo.all
  end

  defp create(params) do
    with {:ok, case_file} <- create_or_update(params) do
      case_file
      |> Repo.preload([:attorney,
                       :correspondent,
                       :case_file_statements,
                       :case_file_event_statements,
                       :case_file_owners])
      |> associate_owners(params)
      |> CaseFile.changeset(params)
      |> put_change(:attorney_id,
                    Attorney.create_or_update(params))
      |> put_change(:correspondent_id,
                    Correspondent.create_or_update(params[:correspondent]))
      |> put_change(:case_file_statements,
                    CaseFileStatement.create_or_update_all(params[:case_file_statements],case_file))
      |> put_change(:case_file_event_statements,
                    CaseFileEventStatement.create_or_update_all(params[:case_file_event_statements], case_file))
      |> Repo.insert_or_update
      |> case do
           {:ok, case_file}    -> {:ok, case_file}
           {:error, changeset} -> {:error, changeset}
         end
    else
      {:error, changeset} ->
        Logger.error fn ->
          """
          Invalid changeset for case file serial number: #{inspect(params[:serial_number])},
          params: #{inspect(params)},
          changeset: #{inspect(changeset)}
          """
        end
      _ ->
        Logger.error fn ->
          "Something went wrong with params: #{inspect(params)}"
        end
    end
  end

  defp associate_owners(case_file, params) do
    params[:case_file_owners]
    |> Enum.map(&CaseFileOwner.create_or_update/1)
    |> Enum.map(fn({:ok, case_file_owner}) -> case_file_owner end)
    |> Enum.map(fn(case_file_owner) ->
         cs = CaseFilesCaseFileOwner.changeset(
                %CaseFilesCaseFileOwner{}, %{case_file_id: case_file.id,
                                             case_file_owner_id: case_file_owner.id}
              )
         Repo.insert(cs, on_conflict: :nothing)
       end)
    case_file
  end

  defp create_or_update(params) do
    case Repo.get_by(CaseFile, serial_number: params[:serial_number]) do
      nil  -> %CaseFile{serial_number: params[:serial_number]}
      case_file -> case_file
    end
    |> CaseFile.changeset(params)
    |> Repo.insert_or_update
    |> case do
         {:ok, case_file}    -> {:ok, case_file}
         {:error, changeset} -> {:error, changeset}
       end
  end

  defp validate_date_format(cs, params) do
    dates = [params[:filing_date],
             params[:registration_date],
             params[:renewal_date],
             params[:date]]
    if Enum.any?(dates, fn(date)-> ParamsFormatter.is_date(date) end) == false do
      add_error(cs, :case_files, "case_file")
    else
      cs
    end
  end
end