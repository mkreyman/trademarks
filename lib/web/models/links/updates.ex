defmodule Trademarks.Models.Links.Updates do
  @moduledoc """
  CRUD operations for "Updates" links between EventStatement and CaseFile.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{EventStatement, CaseFile}

  defstruct [:updates_id]

  @type t :: %Updates{updates_id: String.t()}

  def object_keys() do
    [:updates_id]
  end

  def empty_instance() do
    %Updates{updates_id: uuid1()}
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

  def link(%CaseFile{} = case_file, %EventStatement{} = event_statement) do
    make(event_statement, case_file, empty_instance())
  end

  def unlink(%CaseFile{} = case_file, %EventStatement{} = event_statement) do
    break(event_statement, case_file, %Updates{})
  end

  def validate(%Updates{} = updates) do
    updates
  end
end
