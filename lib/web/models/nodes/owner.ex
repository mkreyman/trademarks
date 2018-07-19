defmodule Trademarks.Models.Nodes.Owner do
  @moduledoc """
  CRUD operations for Owner nodes.
  """

  use Util.StructUtils

  # import UUID
  import Neo4j.Core, only: [exec_query: 2]
  import Neo4j.NodeCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Address, CaseFile, Trademark, Attorney}
  alias Trademarks.Models.Links.{Represents, Locates, BelongsTo}

  defstruct [
    :name,
    :dba,
    :nationality_state,
    :nationality_country,
    :label
  ]

  @type t :: %Owner{
          name: String.t(),
          dba: String.t(),
          nationality_state: String.t(),
          nationality_country: String.t(),
          label: String.t()
        }

  def object_keys() do
    [:name]
  end

  def empty_instance() do
    %Owner{label: struct_to_name()}
  end

  @doc """
  CRUD create operation for Owner.

  ## Parameters

    - owner: a Owner instance to store in the database.

  ## Returns

    Owner instance of the stored value.
  """
  def create(%Owner{name: name} = owner) when is_nil(name) do
    owner
    |> struct(name: struct_to_name())
    |> exec_create()
  end

  def create(%Owner{name: name} = owner) do
    %{owner | name: String.upcase(name), label: struct_to_name()}
    |> exec_create()
  end

  @doc """
  CRUD update operation for Owner.
  Note that the key data for the Owner will not be updated! It is used only to update non-key fields.  To replace a
  Owner's key fields, delete and recreate the Owner.

  ## Parameters

    - owner: a Owner instance to update in the database.

  ## Returns

    Owner instance of the updated value.
  """
  def update(%Owner{} = owner) do
    exec_update(owner)
  end

  @doc """
  CRUD delete operation for Owner.

  ## Parameters

    - owner: a Owner instance to remove from the database. Matches only on key data.

  ## Returns

    Owner instance of the dropped value.
  """
  def delete(%Owner{} = owner) do
    exec_delete(owner)
  end

  @doc """
  CRUD read operation for Owner.

  ## Parameters

    - (overload) owner: a Owner instance whose key values are used to find a Owner in the database.
    - (overload) owners: A list of Owner instances whose key values are used to find matching Owners in the database.
    - (overload) case_file: a CaseFile instance whose key values are used to find an associated Owner in the database.

  ## Returns

    Owner instance of the matching value or nil if a single Owner is passed.
    A list of matching Owner instances or [] if a list of Owners is passed.
  """
  def find(owners) when is_list(owners) do
    exec_find(owners)
  end

  def find(%Owner{} = owner) do
    exec_find(owner)
  end

  @doc """
  Look up Owner by its parent CaseFile.

  ## Parameters

    - (overload) case_file: a CaseFile instance whose key values are used to find an associated Owner in the database.

  ## Returns

    Owner instance of the matching value or nil if doesn't exist.
  """

  def find_by_case_file(%CaseFile{} = case_file) do
    "MATCH (o:Owner)-[:PartyTo]->(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN o"
    |> exec_query(empty_instance())
  end

  def find_by_case_file(%{serial_number: _serial_number} = case_file) do
    "MATCH (o:Owner)-[:PartyTo]->(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN o"
    |> exec_query(empty_instance())
  end

  @doc """
  Adds the given child node to the parent Owner node.

  ## Parameters

    - parent: the parent Owner node to add the child to.
    - child: child node for the Owner.
    - link: the link to join the child node to the parent node.

  # Returns

    - The child node added (either passed or new if generated).

  """
  def add(%Owner{} = parent, %Attorney{} = child) do
    Represents.link(parent, child)
  end

  def add(%Owner{} = parent, %Address{} = child) do
    Locates.link(parent, child)
  end

  def add(%Owner{} = parent, %Trademark{} = child) do
    BelongsTo.link(parent, child)
  end

  @doc """
  Removes the specified child node from the Owner if present
  Note: No action will be taken if the child node is not currently linked to the parent Owner node.
  Note: Owner will not be removed when the child node is deleted.

  ## Parameters

    - parent: the Owner node to remove the child node from.
    - child: key data specifying the child node to unlink from the parent Owner node.

  # Returns

    The unlinked child node (to confirm the link breakage) or nil if the child node was not found.
  """
  def remove(%Owner{} = parent, %Attorney{} = child) do
    Represents.unlink(parent, child)
  end

  def remove(%Owner{} = parent, %Address{} = child) do
    Locates.unlink(parent, child)
  end

  def remove(%Owner{} = parent, %Trademark{} = child) do
    BelongsTo.unlink(parent, child)
  end

  def validate(%Owner{} = owner) do
    owner
  end
end
