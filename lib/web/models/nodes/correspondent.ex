defmodule Trademarks.Models.Nodes.Correspondent do
  @moduledoc """
  CRUD operations for Correspondent nodes.
  """

  use Util.StructUtils

  import Neo4j.Core, only: [exec_query: 2]
  import Neo4j.NodeCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.CaseFile

  defstruct [
    :address_1,
    :address_2,
    :address_3,
    :address_4,
    :address_5,
    :label,
    :hash
  ]

  @type t :: %Correspondent{
          address_1: String.t(),
          address_2: String.t(),
          address_3: String.t(),
          address_4: String.t(),
          address_5: String.t(),
          label: String.t(),
          hash: String.t()
        }

  def object_keys() do
    [:address_1, :hash]
  end

  def empty_instance() do
    %Correspondent{label: struct_to_name()}
  end

  @doc """
  CRUD create operation for Correspondent.

  ## Parameters

    - correspondent: a Correspondent instance to store in the database.

  ## Returns

    Correspondent instance of the stored value.
  """
  def create(%Correspondent{address_1: address_1} = correspondent) when is_nil(address_1) do
    correspondent
    |> struct(label: struct_to_name())
    |> exec_create()
  end

  def create(%Correspondent{address_1: address_1, address_2: address_2} = correspondent) do
    address_1 =
      address_1 ||
        address_2
        |> String.replace("\"", "'")

    address_2 =
      case address_2 == address_1 do
        true ->
          nil

        _ ->
          address_2
          |> String.replace("\"", "'")
      end

    """
      MERGE (c:Correspondent {hash: apoc.util.md5([UPPER(\"#{address_1}\"), UPPER(\"#{address_2}\"), UPPER(\"#{
      correspondent.address_3
    }\"), UPPER(\"#{correspondent.address_4}\"), UPPER(\"#{correspondent.address_5}\")])})
      ON CREATE SET c.address_1 = UPPER(\"#{address_1}\"),
                    c.address_2 = UPPER(\"#{address_2}\"),
                    c.address_3 = UPPER(\"#{correspondent.address_3}\"),
                    c.address_4 = UPPER(\"#{correspondent.address_4}\"),
                    c.address_5 = UPPER(\"#{correspondent.address_5}\"),
                    c.label = \"#{struct_to_name()}\"
      RETURN c
    """
    |> String.replace("\n", " ")
    |> exec_query(%Correspondent{})
  end

  @doc """
    Search operation for Correspondents

    ## Parameters

      - correspondent: a Correspondent instance with fields to use to search for matching instances in the database.

    ## Returns

      - A list of matching Correspondent instances.
  """
  def search(%Correspondent{} = correspondent) do
    exec_search(correspondent)
  end

  @doc """
  CRUD update operation for Correspondent.
  Note that the key data for the Correspondent will not be updated! It is used only to update non-key fields.  To replace a
  Correspondent's key fields, delete and recreate the Correspondent.

  ## Parameters

    - correspondent: a Correspondent instance to update in the database.

  ## Returns

    Correspondent instance of the updated value.
  """
  def update(%Correspondent{} = correspondent) do
    exec_update(correspondent)
  end

  @doc """
  CRUD delete operation for Correspondent.

  ## Parameters

    - correspondent: a Correspondent instance to remove from the database. Matches only on key data.

  ## Returns

    Correspondent instance of the dropped value.
  """
  def delete(%Correspondent{} = correspondent) do
    exec_delete(correspondent)
  end

  @doc """
  CRUD read operation for Correspondent.

  ## Parameters

    - (overload) correspondent: a Correspondent instance whose key values are used to find an Correspondent in the database.
    - (overload) corrspondents: A list of Correspondent instances whose key values are used to find matching Correspondents in the database.
    - (overload) case_file: a CaseFile instance whose key values are used to find an associated Correspondent in the database.

  ## Returns

    Correspondent instance of the matching value or nil if a single Correspondent is passed.
    A list of matching Correspondent instances or [] if a list of Correspondents is passed.
  """
  def find(correspondents) when is_list(correspondents) do
    exec_find(correspondents)
  end

  def find(%Correspondent{} = correspondent) do
    exec_find(correspondent)
  end

  @doc """
  Look up Correspondent by its parent CaseFile.

  ## Parameters

    - (overload) case_file: a CaseFile instance whose key values are used to find an associated Correspondent in the database.

  ## Returns

    Correspondent instance of the matching value or nil if doesn't exist.
  """

  def find_by_case_file(%CaseFile{} = case_file) do
    "MATCH (cf:CaseFile)-[:CommunicatesWith]->(c:Correspondent) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN c"
    |> exec_query(empty_instance())
  end

  def find_by_case_file(%{serial_number: _serial_number} = case_file) do
    "MATCH (cf:CaseFile)-[:CommunicatesWith]->(c:Correspondent) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN c"
    |> exec_query(empty_instance())
  end

  def validate(%Correspondent{} = correspondent) do
    correspondent
  end
end
