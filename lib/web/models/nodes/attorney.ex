defmodule Trademarks.Models.Nodes.Attorney do
  @moduledoc """
  CRUD operations for Attorney nodes.
  """

  use Util.StructUtils

  # import UUID
  import Neo4j.Core, only: [exec_query: 2]
  import Neo4j.NodeCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.CaseFile

  defstruct [:name, :label]

  @type t :: %Attorney{
          name: String.t(),
          label: String.t()
        }

  def object_keys() do
    [:name]
  end

  def empty_instance() do
    %Attorney{label: struct_to_name()}
  end

  @doc """
  CRUD create operation for Attorney.

  ## Parameters

    - attorney: a Attorney instance to store in the database.

  ## Returns

    Attorney instance of the stored value.
  """
  def create(%Attorney{name: name} = attorney) when is_nil(name) do
    attorney
    |> struct(label: struct_to_name())
    |> exec_create()
  end

  # def create(%Attorney{name: name} = attorney) do
  #   %{attorney | name: String.upcase(name), label: struct_to_name()}
  #   |> exec_create()
  # end

  def create(%Attorney{name: name}) do
    name =
      name
      |> String.replace("\"", "'")

    """
      MERGE (a:Attorney {name: UPPER(\"#{name}\"), label: \"#{struct_to_name()}\"})
      RETURN a
    """
    |> String.replace("\n", " ")
    |> exec_query(%Attorney{})
  end

  @doc """
    Search operation for Attorneys

    ## Parameters

      - attorney: a Attorney instance with fields to use to search for matching instances in the database.

    ## Returns

      - A list of matching Attorney instances.
  """
  def search(%Attorney{} = attorney) do
    exec_search(attorney)
  end

  @doc """
    Combines find and create operations for Attorneys

    ## Parameters

      - attorney: an Attorney instance with key data to use to find the instance in the database.

    ## Returns

      - Attorney instance that was found or created.
  """
  def find_or_create(%Attorney{} = attorney) do
    case search(attorney) do
      %Attorney{} = attorney -> attorney
      nil -> create(attorney)
    end
  end

  @doc """
  CRUD update operation for Attorney.
  Note that the key data for the Attorney will not be updated! It is used only to update non-key fields.  To replace a
  Attorney's key fields, delete and recreate the Attorney.

  ## Parameters

    - attorney: a Attorney instance to update in the database.

  ## Returns

    Attorney instance of the updated value.
  """
  def update(%Attorney{} = attorney) do
    exec_update(attorney)
  end

  @doc """
  CRUD delete operation for Attorney.

  ## Parameters

    - attorney: a Attorney instance to remove from the database. Matches only on key data.

  ## Returns

    Attorney instance of the dropped value.
  """
  def delete(%Attorney{} = attorney) do
    exec_delete(attorney)
  end

  @doc """
  CRUD read operation for Attorney.

  ## Parameters

    - (overload) attorney: a Attorney instance whose key values are used to find a Attorney in the database.
    - (overload) attorneys: A list of Attorney instances whose key values are used to find matching Attorneys in the database.
    - (overload) case_file: a CaseFile instance whose key values are used to find an associated Attorney in the database.

  ## Returns

    Attorney instance of the matching value or nil if a single Attorney is passed.
    A list of matching Attorney instances or [] if a list of Attorneys is passed.
  """
  def find(attorneys) when is_list(attorneys) do
    exec_find(attorneys)
  end

  def find(%Attorney{} = attorney) do
    exec_find(attorney)
  end

  @doc """
  Look up Attorney by its parent CaseFile.

  ## Parameters

    - (overload) case_file: a CaseFile instance whose key values are used to find an associated Attorney in the database.

  ## Returns

    Attorney instance of the matching value or nil if doesn't exist.
  """

  def find_by_case_file(%CaseFile{} = case_file) do
    "MATCH (cf:CaseFile)-[:FILED_BY]->(a:Attorney) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN a"
    |> exec_query(empty_instance())
  end

  def find_by_case_file(%{serial_number: _serial_number} = case_file) do
    "MATCH (cf:CaseFile)-[:FILED_BY]->(a:Attorney) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN a"
    |> exec_query(empty_instance())
  end

  def validate(%Attorney{} = attorney) do
    attorney
  end
end
