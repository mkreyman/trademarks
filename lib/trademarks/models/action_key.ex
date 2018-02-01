defmodule Trademarks.ActionKey do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{ActionKey, CaseFile, Repo}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "action_keys" do
    field :action_key_code, :string
    has_many :case_files, CaseFile, on_delete: :delete_all

    timestamps()
  end

  @fields ~w(action_key_code)

  def process(stream) do
    stream
    |> Enum.map(&create(&1))
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:action_key_code])
    |> cast_assoc(:case_files)
  end

  def create(params) do
    cs = changeset(%ActionKey{}, params)

    if cs.valid? do
      Repo.insert(cs)
    else
      Logger.error "Invalid changeset: #{IO.inspect(cs)}"
      cs
    end
  end
end