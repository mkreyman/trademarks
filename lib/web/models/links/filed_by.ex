defmodule Trademarks.Models.Links.FiledBy do
  @moduledoc """
  CRUD operations for "FiledBy" links between CaseFile and Attorney.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{CaseFile, Attorney}

  defstruct [:filed_by_id]

  @type t :: %FiledBy{filed_by_id: String.t()}

  def object_keys() do
    [:filed_by_id]
  end

  def empty_instance() do
    %FiledBy{filed_by_id: uuid1()}
  end

  @doc """
  CRUD create operation for a FiledBy relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new FiledBy node.

  ## Returns

    FiledBy instance to be used to join CaseFile to Attorney
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%CaseFile{} = case_file, %Attorney{} = attorney) do
    make(case_file, attorney, empty_instance())
  end

  def unlink(%CaseFile{} = case_file, %Attorney{} = attorney) do
    break(case_file, attorney, %FiledBy{})
  end

  def validate(%FiledBy{} = filed_by) do
    filed_by
  end
end
