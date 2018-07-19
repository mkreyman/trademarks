defmodule Trademarks.Models.Nodes.CaseFile do
  @moduledoc """
  CRUD operations for CaseFile nodes.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.PipeDebug

  import Neo4j.Core, only: [exec_query: 2]
  import Neo4j.NodeCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Trademark, Attorney, Owner, Statement, EventStatement}
  alias Trademarks.Models.Links.{Files, PartyTo, Describes, Updates}

  defstruct [
    :serial_number,
    :abandonment_date,
    :filing_date,
    :registration_date,
    :registration_number,
    :renewal_date,
    :status_date,
    :label
  ]

  @type t :: %CaseFile{
          serial_number: String.t(),
          abandonment_date: integer,
          filing_date: integer,
          registration_date: integer,
          registration_number: String.t(),
          renewal_date: integer,
          status_date: integer,
          label: String.t()
        }

  def object_keys() do
    [:serial_number]
  end

  def empty_instance() do
    %CaseFile{label: struct_to_name()}
  end

  @doc """
  Find all case_files for a given Trademark.

  ## Parameters

    - trademark: the trademark to query for matching CaseFiles.

  ## Returns

    - A collection of case_files for a given Trademark.
  """
  def find_by_trademark(%Trademark{} = trademark) do
    "MATCH (tm:Trademark)<-[:FiledFor]-(cf:CaseFile) WHERE tm.name = \"#{trademark.name}\" RETURN cf"
    |> exec_query(empty_instance())
  end

  def find_by_trademark(%{name: _name} = trademark) do
    "MATCH (tm:Trademark)<-[:FiledFor]-(cf:CaseFile) WHERE tm.name = \"#{trademark.name}\" RETURN cf"
    |> exec_query(empty_instance())
  end

  @doc """
  CRUD create operation for CaseFile.

  ## Parameters

    - case_file: a CaseFile instance to store in the database.

  ## Returns

    CaseFile instance of the stored value.
  """
  def create(%CaseFile{} = case_file) do
    exec_create(case_file)
  end

  def create(%{} = case_file) do
    case_file
    |> struct_from_map()
    |> exec_create()
  end

  @doc """
    Search operation for CaseFiles

    ## Parameters

      - case_file: a CaseFile instance with fields to use to search for matching instances in the database.

    ## Returns

      - A list of matching CaseFile instances.
  """
  def search(%CaseFile{} = case_file) do
    exec_search(case_file)
  end

  @doc """
    Combines find and create operations for CaseFiles

    ## Parameters

      - case_file: an CaseFile instance with key data to use to find the instance in the database.

    ## Returns

      - CaseFile instance that was found or created.
  """
  def find_or_create(%CaseFile{} = case_file) do
    case search(case_file) do
      %CaseFile{} = case_file -> case_file
      nil -> create(case_file)
    end
  end

  @doc """
  CRUD update operation for CaseFile.
  Note that the key data for the CaseFile will not be updated!  It is used only to update non-key fields.  To replace a
  CaseFile's key fields, delete and recreate the CaseFile.

  ## Parameters

    - case_file: a CaseFile instance to update in the database.

  ## Returns

    CaseFile instance of the updated value.
  """
  def update(%CaseFile{} = case_file) do
    exec_update(case_file)
  end

  @doc """
  CRUD delete operation for CaseFile.

  ## Parameters

    - case_file: a CaseFile instance to remove from the database.  Matches only on key data.

  ## Returns

    CaseFile instance of the dropped value.
  """
  def delete(%CaseFile{} = case_file) do
    exec_delete(case_file)
  end

  def delete(nil, _) do
    nil
  end

  @doc """
  CRUD read operation for CaseFile.

  ## Parameters

    - (overload) case_file: a CaseFile instance whose key values are used to find a CaseFile in the database.
    - (overload) case_files: A list of CaseFile instances whose key values are used to find matching CaseFiles in the database.

  ## Returns

    CaseFile instance of the matching value or nil if a single CaseFile is passed.
    A list of matching CaseFile instances or [] if a list of CaseFiles is passed.
  """
  def find(case_files) when is_list(case_files) do
    exec_find(case_files)
  end

  def find(%CaseFile{} = case_file) do
    exec_find(case_file)
  end

  @doc """
  Adds the given child node to the parent CaseFile node.

  ## Parameters

    - parent: the CaseFile node to add the child node to as a leaf.
    - child: child node.
    - link: the link to join the child node to the parent node.

  # Returns

    - The child node added (either passed or new if generated).

  """
  def add(%CaseFile{} = parent, %Attorney{} = child) do
    Files.link(parent, child)
  end

  def add(%CaseFile{} = parent, %Owner{} = child) do
    PartyTo.link(parent, child)
  end

  def add(%CaseFile{} = parent, %Statement{} = child) do
    Describes.link(parent, child)
  end

  def add(%CaseFile{} = parent, %EventStatement{} = child) do
    Updates.link(parent, child)
  end

  @doc """
  Removes the specified child node from the set of child nodes attached to the CaseFile if present
  Note: No action will be taken if the child node is not currently linked to the parent CaseFile node.
  Note: CaseFile will not be removed when the last child node is deleted.

  ## Parameters

    - parent: the CaseFile node to remove the child node from.
    - child: key data specifying the child node to unlink from the parent CaseFile node.

  # Returns

    The unlinked child node (to confirm the link breakage) or nil if the child node was not found.
  """
  def remove(%CaseFile{} = parent, %Attorney{} = child) do
    Files.unlink(parent, child)
  end

  def remove(%CaseFile{} = parent, %Owner{} = child) do
    PartyTo.unlink(parent, child)
  end

  def remove(%CaseFile{} = parent, %Statement{} = child) do
    Describes.unlink(parent, child)
  end

  def remove(%CaseFile{} = parent, %EventStatement{} = child) do
    Updates.unlink(parent, child)
  end

  def validate(%CaseFile{} = case_file) do
    case_file
  end
end
