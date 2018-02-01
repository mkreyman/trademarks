defmodule Trademarks.ActionKey do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    ActionKey,
    CaseFile,
    CaseFileStatement,
    CaseFileEventStatement,
    CaseFileOwner,
    Correspondent,
    Repo
    }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "action_keys" do
    field :action_key_code, :string
    has_many :case_files, CaseFile, on_delete: :delete_all

    timestamps
  end

  @fields ~w(action_key_code)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:action_key_code])
  end

  def create(params) do
    cs = changeset(%ActionKey{}, params)
         |> put_assoc(:case_files, get_case_files(params))

    if cs.valid? do
      Repo.insert(cs)
    else
      Logger.error "Invalid changeset: #{IO.inspect(cs)}"
      cs
    end
  end

  def get_case_files(params) do
    case_files = params[:case_files]
    Enum.map(case_files, fn(case_file) ->
      CaseFile.changeset(%CaseFile{}, case_file)
    end)
  end

  def process(stream) do
    stream
    |> Stream.map()
    |> Enum.map(&create(&1))
  end
end