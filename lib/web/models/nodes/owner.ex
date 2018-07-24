defmodule Trademarks.Models.Nodes.Owner do
  @moduledoc """
  CRUD operations for Owner nodes.
  """

  use Util.StructUtils

  # import UUID
  import Neo4j.Core, only: [exec_query: 2]
  import Neo4j.NodeCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.CaseFile

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
    |> struct(label: struct_to_name())
    |> exec_create()
  end

  # def create(%Owner{name: name} = owner) do
  #   %{owner | name: String.upcase(name), label: struct_to_name()}
  #   |> exec_create()
  # end

  def create(%Owner{name: name} = owner) do
    name =
      name
      |> String.replace("\"", "'")

    """
      MERGE (o:Owner {name: UPPER(\"#{name}\")})
      ON CREATE SET o.dba = UPPER(\"#{owner.dba}\"),
                    o.nationality_state = \"#{owner.nationality_state}\",
                    o.nationality_country = \"#{owner.nationality_country}\",
                    o.label = \"#{struct_to_name()}\"
      RETURN o
    """
    |> String.replace("\n", " ")
    |> exec_query(%Owner{})
  end

  @doc """
    Search operation for Owners

    ## Parameters

      - owner: a Owner instance with fields to use to search for matching instances in the database.

    ## Returns

      - A list of matching Owner instances.
  """
  def search(%Owner{} = owner) do
    exec_search(owner)
  end

  @doc """
    Combines find and create operations for Owners

    ## Parameters

      - owner: an Owner instance with key data to use to find the instance in the database.

    ## Returns

      - Owner instance that was found or created.
  """
  def find_or_create(%Owner{name: name} = owner) do
    owner = %{owner | name: String.upcase(name)}

    case search(owner) do
      %Owner{} = owner -> owner
      nil -> create(owner)
    end
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
    "MATCH (o:Owner)-[:PARTY_TO]->(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN o"
    |> exec_query(empty_instance())
  end

  def find_by_case_file(%{serial_number: _serial_number} = case_file) do
    "MATCH (o:Owner)-[:PARTY_TO]->(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN o"
    |> exec_query(empty_instance())
  end

  def validate(%Owner{} = owner) do
    owner
  end
end
