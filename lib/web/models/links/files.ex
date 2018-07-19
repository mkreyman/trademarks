defmodule Trademarks.Models.Links.Files do
  @moduledoc """
  CRUD operations for "Files" links between Attorney and CaseFile.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Attorney, CaseFile}

  defstruct [:files_id]

  @type t :: %Files{files_id: String.t()}

  def object_keys() do
    [:files_id]
  end

  def empty_instance() do
    %Files{files_id: uuid1()}
  end

  @doc """
  CRUD create operation for a Files relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new Files node.

  ## Returns

    Files instance to be used to join Attorney to CaseFile.
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%CaseFile{} = case_file, %Attorney{} = attorney) do
    make(attorney, case_file, empty_instance())
  end

  def unlink(%CaseFile{} = case_file, %Attorney{} = attorney) do
    break(attorney, case_file, %Files{})
  end

  def validate(%Files{} = files) do
    files
  end
end
