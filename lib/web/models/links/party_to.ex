defmodule Trademarks.Models.Links.PartyTo do
  @moduledoc """
  CRUD operations for "PartyTo" links between Owner and CaseFile.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Owner, CaseFile}

  defstruct [:party_to_id, :label]

  @type t :: %PartyTo{
          party_to_id: String.t(),
          label: String.t()
        }

  def object_keys() do
    [:party_to_id]
  end

  def empty_instance() do
    %PartyTo{party_to_id: uuid1(), label: struct_to_name()}
  end

  @doc """
  CRUD create operation for a PartyTo relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new PartyTo node.

  ## Returns

    PartyTo instance to be used to join Owner to CaseFile
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%CaseFile{} = case_file, %Owner{} = owner) do
    make(owner, case_file, empty_instance())
  end

  def unlink(%CaseFile{} = case_file, %Owner{} = owner) do
    break(owner, case_file, %PartyTo{})
  end

  def validate(%PartyTo{} = party_to) do
    party_to
  end
end
