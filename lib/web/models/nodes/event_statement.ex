defmodule Trademarks.Models.Nodes.EventStatement do
  @moduledoc """
  CRUD operations for EventStatement nodes.
  """

  use Util.StructUtils

  # import UUID
  import Neo4j.Core, only: [exec_query: 2]
  import Neo4j.NodeCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.CaseFile

  defstruct [:date, :description, :hash, :label]

  @type t :: %EventStatement{
          date: integer,
          description: String.t(),
          hash: String.t(),
          label: String.t()
        }

  def object_keys() do
    [:date, :description, :hash]
  end

  def empty_instance() do
    %EventStatement{label: struct_to_name()}
  end

  @doc """
  CRUD create operation for EventStatement.

  ## Parameters

    - event_statement: a EventStatement instance to store in the database.

  ## Returns

    EventStatement instance of the stored value.
  """
  def create(%EventStatement{description: description} = event_statement)
      when is_nil(description) do
    event_statement
    |> struct(label: struct_to_name())
    |> exec_create()
  end

  # def create(%EventStatement{description: description} = event_statement) do
  #   %{event_statement | description: description, hash: md5(description), label: struct_to_name()}
  #   |> exec_create()
  # end

  def create(%EventStatement{date: date, description: description} = event_statement) do
    description =
      description
      |> String.replace("\"", "'")

    """
      MERGE (es:EventStatement {hash: apoc.util.md5([\"#{description}\", toInt(\"#{date}\")])})
      ON CREATE SET es.description = \"#{description}\",
                    es.date = toInt(\"#{date}\"),
                    es.label = \"#{struct_to_name()}\"
      RETURN es
    """
    |> String.replace("\n", " ")
    |> exec_query(%EventStatement{})
  end

  @doc """
    Search operation for EventStatements

    ## Parameters

      - event_statement: a EventStatement instance with fields to use to search for matching instances in the database.

    ## Returns

      - A list of matching EventStatement instances.
  """
  def search(%EventStatement{} = event_statement) do
    exec_search(event_statement)
  end

  @doc """
    Combines find and create operations for EventStatements

    ## Parameters

      - event_statement: an EventStatement instance with key data to use to find the instance in the database.

    ## Returns

      - EventStatement instance that was found or created.
  """
  def find_or_create(%EventStatement{} = event_statement) do
    case search(event_statement) do
      %EventStatement{} = event_statement -> event_statement
      nil -> create(event_statement)
    end
  end

  @doc """
  CRUD update operation for EventStatement.
  Note that the key data for the EventStatement will not be updated! It is used only to update non-key fields.  To replace a
  EventStatement's key fields, delete and recreate the EventStatement.

  ## Parameters

    - event_statement: a EventStatement instance to update in the database.

  ## Returns

    EventStatement instance of the updated value.
  """
  def update(%EventStatement{} = event_statement) do
    exec_update(event_statement)
  end

  @doc """
  CRUD delete operation for EventStatement.

  ## Parameters

    - event_statement: a EventStatement instance to remove from the database. Matches only on key data.

  ## Returns

    EventStatement instance of the dropped value.
  """
  def delete(%EventStatement{} = event_statement) do
    exec_delete(event_statement)
  end

  @doc """
  CRUD read operation for EventStatement.

  ## Parameters

    - (overload) event_statement: a EventStatement instance whose key values are used to find a EventStatement in the database.
    - (overload) event_statements: A list of EventStatement instances whose key values are used to find matching EventStatements in the database.
    - (overload) case_file: a CaseFile instance whose key values are used to find an associated EventStatement in the database.

  ## Returns

    EventStatement instance of the matching value or nil if a single EventStatement is passed.
    A list of matching EventStatement instances or [] if a list of EventStatements is passed.
  """
  def find(event_statements) when is_list(event_statements) do
    exec_find(event_statements)
  end

  def find(%EventStatement{} = event_statement) do
    exec_find(event_statement)
  end

  @doc """
  Look up EventStatement by its parent CaseFile.

  ## Parameters

    - (overload) case_file: a CaseFile instance whose key values are used to find an associated EventStatement in the database.

  ## Returns

    EventStatement instance of the matching value or nil if doesn't exist.
  """

  def find_by_case_file(%CaseFile{} = case_file) do
    "MATCH (es:EventStatement)-[:Updates]->(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN es"
    |> exec_query(empty_instance())
  end

  def find_by_case_file(%{serial_number: _serial_number} = case_file) do
    "MATCH (es:EventStatement)-[:Updates]->(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN es"
    |> exec_query(empty_instance())
  end

  def validate(%EventStatement{} = event_statement) do
    event_statement
  end

  defp md5(description) do
    :crypto.hash(:md5, description) |> Base.encode16()
  end
end
