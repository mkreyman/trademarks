defmodule Trademarks.Models.Links.FiledFor do
  @moduledoc """
  CRUD operations for "FiledFor" links between CaseFile and Trademark.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{CaseFile, Trademark}

  defstruct [:filed_for_id]

  @type t :: %FiledFor{filed_for_id: String.t()}

  def object_keys() do
    [:filed_for_id]
  end

  def empty_instance() do
    %FiledFor{filed_for_id: uuid1()}
  end

  @doc """
  CRUD create operation for a FiledFor relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new FiledFor relationship.

  ## Returns

    FiledFor instance to be used to join CaseFile to Trademark.
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%CaseFile{} = case_file, %Trademark{} = trademark) do
    make(case_file, trademark, empty_instance())
  end

  def unlink(%CaseFile{} = case_file, %Trademark{} = trademark) do
    break(case_file, trademark, %FiledFor{})
  end

  def validate(%FiledFor{} = filed_for) do
    filed_for
  end
end
