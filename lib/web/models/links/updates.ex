defmodule Trademarks.Models.Links.Updates do
  @moduledoc """
  CRUD operations for "Updates" links between EventStatement and CaseFile.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.InterfaceBase

  import UUID
  import Neo4j.Core, only: [neo_today: 0]
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{EventStatement, CaseFile}

  defstruct [:updates_id, :date]

  @type t :: %Updates{
          updates_id: String.t(),
          date: Integer.t()
        }

  def object_keys() do
    [:updates_id, :date]
  end

  def empty_instance(date \\ neo_today())

  def empty_instance(date) when is_integer(date) do
    %Updates{updates_id: uuid1(), date: date}
  end

  def empty_instance(date) when is_binary(date) do
    %Updates{updates_id: uuid1(), date: String.to_integer(date)}
  end

  @doc """
  CRUD create operation for a Updates relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new Updates node.

  ## Returns

    Updates instance to be used to join EventStatement to CaseFile
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%EventStatement{} = event_statement, %CaseFile{} = case_file) do
    make(event_statement, case_file, empty_instance())
  end

  def link(%EventStatement{} = event_statement, %CaseFile{} = case_file, date) do
    make(event_statement, case_file, empty_instance(date))
  end

  def unlink(%EventStatement{} = event_statement, %CaseFile{} = case_file) do
    break(event_statement, case_file, %Updates{})
  end

  def validate(%Updates{} = updates) do
    updates
  end
end
