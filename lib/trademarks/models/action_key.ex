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
    |> unique_constraint(:action_key_code, name: :action_keys_action_key_code_index)
    |> validate_required([:action_key_code])
    |> cast_assoc(:case_files)
  end

  def create(params) do
    try do
      cs = changeset(%ActionKey{}, params)

      if cs.valid? do
        Repo.insert_or_update(cs)
      else
        Logger.error "=========================================="
        Logger.error "Changeset errors: #{IO.inspect(cs)}"
        Logger.error "=========================================="
        # cs
      end
    rescue
      Protocol.UndefinedError -> Logger.error "Changeset errors: #{IO.inspect(params)}"
    end
  end
end