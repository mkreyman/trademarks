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
  alias Trademarks.Models.Nodes.CaseFile

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
    "MATCH (tm:Trademark)<-[:FILED_FOR]-(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN tm"
    |> exec_query(empty_instance())
  end

  def find_by_case_file(%{serial_number: _serial_number} = case_file) do
    "MATCH (tm:Trademark)<-[:FILED_FOR]-(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN tm"
    |> exec_query(empty_instance())
  end

  def validate(%Trademark{} = trademark) do
    trademark
  end
end
