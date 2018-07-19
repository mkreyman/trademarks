defmodule Trademarks.Models.Links.CommunicatesWith do
  @moduledoc """
  CRUD operations for "CommunicatesWith" links between CaseFile and Correspondent.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{CaseFile, Correspondent}

  defstruct [:communicates_with_id]

  @type t :: %CommunicatesWith{communicates_with_id: String.t()}

  def object_keys() do
    [:communicates_with_id]
  end

  def empty_instance() do
    %CommunicatesWith{communicates_with_id: uuid1()}
  end

  @doc """
  CRUD create operation for a CommunicatesWith relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new CommunicatesWith node.

  ## Returns

    FiledBy instance to be used to join CaseFile to Correspondent
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%Correspondent{} = correspondent, %CaseFile{} = case_file) do
    make(case_file, correspondent, empty_instance())
  end

  def unlink(%Correspondent{} = correspondent, %CaseFile{} = case_file) do
    break(case_file, correspondent, %CommunicatesWith{})
  end

  def validate(%CommunicatesWith{} = communicates_with) do
    communicates_with
  end
end
