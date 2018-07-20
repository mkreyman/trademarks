defmodule Trademarks.Models.Links.Describes do
  @moduledoc """
  CRUD operations for "Describes" links between Statement and CaseFile.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Statement, CaseFile}

  defstruct [:describes_id]

  @type t :: %Describes{describes_id: String.t()}

  def object_keys() do
    [:describes_id]
  end

  def empty_instance() do
    %Describes{describes_id: uuid1()}
  end

  @doc """
  CRUD create operation for a Describes relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new Describes node.

  ## Returns

    Describes instance to be used to join Statement to CaseFile
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%Statement{} = statement, %CaseFile{} = case_file) do
    make(statement, case_file, empty_instance())
  end

  def unlink(%Statement{} = statement, %CaseFile{} = case_file) do
    break(statement, case_file, %Describes{})
  end

  def validate(%Describes{} = describes) do
    describes
  end
end
