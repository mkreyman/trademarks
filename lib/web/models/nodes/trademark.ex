defmodule Trademarks.Models.Nodes.Trademark do
  @moduledoc """
  CRUD operations for Trademark nodes.
  """

  use Util.StructUtils
  use Util.PipeDebug

  # import UUID
  import Neo4j.Core, only: [exec_query: 2]
  import Neo4j.NodeCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{CaseFile, Owner}
  alias Trademarks.Models.Links.{Owns, FiledFor}

  defstruct [:name, :label]

  @type t :: %Trademark{
          name: String.t(),
          label: String.t()
        }

  def object_keys() do
    [:name]
  end

  def struct_to_name() do
    "TM"
  end

  def empty_instance() do
    %Trademark{label: struct_to_name()}
  end

  @doc """
  CRUD create operation for Trademark.

  ## Parameters

    - trademark: a Trademark instance to store in the database.

  ## Returns

    Trademark instance of the stored value.
  """
  def create(%Trademark{name: name} = trademark) when is_nil(name) do
    trademark
    |> struct(label: struct_to_name())
    |> exec_create()
  end

  # def create(%Trademark{name: name} = trademark) do
  #   %{trademark | name: String.upcase(name), label: struct_to_name()}
  #   |> exec_create()
  # end

  def create(%Trademark{name: name}) do
    name =
      name
      |> String.replace("\"", "'")

    """
      MERGE (tm:Trademark {name: UPPER(\"#{name}\"), label: \"#{struct_to_name()}\"})
      RETURN tm
    """
    |> String.replace("\n", " ")
    |> exec_query(%Trademark{})
  end

  @doc """
    Search operation for Trademarks

    ## Parameters

      - trademark: a Trademark instance with fields to use to search for matching instances in the database.

    ## Returns

      - A list of matching Trademark instances.
  """
  def search(%Trademark{} = trademark) do
    exec_search(trademark)
  end

  @doc """
    Combines find and create operations for Trademarks

    ## Parameters

      - trademark: an Trademark instance with key data to use to find the instance in the database.

    ## Returns

      - Trademark instance that was found or created.
  """
  def find_or_create(%Trademark{} = trademark) do
    case search(trademark) do
      %Trademark{} = trademark -> trademark
      nil -> create(trademark)
    end
  end

  @doc """
  CRUD update operation for Trademark.
  Note that the key data for the Trademark will not be updated! It is used only to update non-key fields.  To replace a
  Trademark's key fields, delete and recreate the Trademark.

  ## Parameters

    - trademark: a Trademark instance to update in the database.

  ## Returns

    Trademark instance of the updated value.
  """
  def update(%Trademark{} = trademark) do
    exec_update(trademark)
  end

  @doc """
  CRUD delete operation for Trademark.

  ## Parameters

    - trademark: a Trademark instance to remove from the database. Matches only on key data.

  ## Returns

    Trademark instance of the dropped value.
  """
  def delete(%Trademark{} = trademark) do
    exec_delete(trademark)
  end

  @doc """
  CRUD read operation for Trademark.

  ## Parameters

    - (overload) trademark: a Trademark instance whose key values are used to find a Trademark in the database.
    - (overload) trademarks: A list of Trademark instances whose key values are used to find matching Trademarks in the database.
    - (overload) case_file: a CaseFile instance whose key values are used to find an associated Trademark in the database.

  ## Returns

    Trademark instance of the matching value or nil if a single Trademark is passed.
    A list of matching Trademark instances or [] if a list of Trademarks is passed.
  """
  def find(trademarks) when is_list(trademarks) do
    exec_find(trademarks)
  end

  def find(%Trademark{} = trademark) do
    exec_find(trademark)
  end

  @doc """
  Look up Trademark by its parent CaseFile.

  ## Parameters

    - (overload) case_file: a CaseFile instance whose key values are used to find an associated Trademark in the database.

  ## Returns

    Trademark instance of the matching value or nil if doesn't exist.
  """

  def find_by_case_file(%CaseFile{} = case_file) do
    "MATCH (tm:Trademark)<-[:FiledFor]-(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN tm"
    |> exec_query(empty_instance())
  end

  def find_by_case_file(%{serial_number: _serial_number} = case_file) do
    "MATCH (tm:Trademark)<-[:FiledFor]-(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN tm"
    |> exec_query(empty_instance())
  end

  @doc """
  Adds the given child node to the parent Trademark node.

  ## Parameters

    - parent: the parent Trademark node to add the child to.
    - child: child node for the Trademark.
    - link: the link to join the child node to the parent node.

  # Returns

    - The child node added (either passed or new if generated).

  """
  def add(%Trademark{} = parent, %CaseFile{} = child) do
    FiledFor.link(parent, child)
  end

  def add(%Trademark{} = parent, %Owner{} = child) do
    Owns.link(parent, child)
  end

  @doc """
  Removes the specified child node from the Trademark if present
  Note: No action will be taken if the child node is not currently linked to the parent Trademark node.
  Note: Trademark will not be removed when the child node is deleted.

  ## Parameters

    - parent: the Trademark node to remove the child node from.
    - child: key data specifying the child node to unlink from the parent Trademark node.

  # Returns

    The unlinked child node (to confirm the link breakage) or nil if the child node was not found.
  """
  def remove(%Trademark{} = parent, %CaseFile{} = child) do
    FiledFor.unlink(parent, child)
  end

  def remove(%Trademark{} = parent, %Owner{} = child) do
    Owns.unlink(parent, child)
  end

  def validate(%Trademark{} = trademark) do
    trademark
  end
end
