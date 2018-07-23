defmodule Trademarks.Models.Nodes.Statement do
  @moduledoc """
  CRUD operations for Statement nodes.
  """

  use Util.StructUtils

  # import UUID
  import Neo4j.Core, only: [exec_query: 2]
  import Neo4j.NodeCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.CaseFile

  defstruct [:description, :hash, :label]

  @type t :: %Statement{
          description: String.t(),
          hash: String.t(),
          label: String.t()
        }

  def object_keys() do
    [:description, :hash]
  end

  def empty_instance() do
    %Statement{label: struct_to_name()}
  end

  @doc """
  CRUD create operation for Statement.

  ## Parameters

    - statement: a Statement instance to store in the database.

  ## Returns

    Statement instance of the stored value.
  """
  def create(%Statement{description: description} = statement) when is_nil(description) do
    statement
    |> struct(label: struct_to_name())
    |> exec_create()
  end

  # def create(%Statement{description: description} = statement) do
  #   %{statement | description: description, hash: md5(description), label: struct_to_name()}
  #   |> exec_create()
  # end

  def create(%Statement{description: description} = statement) do
    description =
      description
      |> String.replace("\"", "'")

    """
      MERGE (s:Statement {hash: apoc.util.md5([\"#{description}\"])})
      ON CREATE SET s.description = \"#{description}\",
                    s.label = \"#{struct_to_name()}\"
      RETURN s
    """
    |> String.replace("\n", " ")
    |> exec_query(%Statement{})
  end

  @doc """
    Search operation for Statements

    ## Parameters

      - statement: a Statement instance with fields to use to search for matching instances in the database.

    ## Returns

      - A list of matching Statement instances.
  """
  def search(%Statement{} = statement) do
    exec_search(statement)
  end

  @doc """
    Combines find and create operations for Statements

    ## Parameters

      - statement: an Statement instance with key data to use to find the instance in the database.

    ## Returns

      - Statement instance that was found or created.
  """
  def find_or_create(%Statement{} = statement) do
    case search(statement) do
      %Statement{} = statement -> statement
      nil -> create(statement)
    end
  end

  @doc """
  CRUD update operation for Statement.
  Note that the key data for the Statement will not be updated! It is used only to update non-key fields.  To replace a
  Statement's key fields, delete and recreate the Statement.

  ## Parameters

    - statement: a Statement instance to update in the database.

  ## Returns

    Statement instance of the updated value.
  """
  def update(%Statement{} = statement) do
    exec_update(statement)
  end

  @doc """
  CRUD delete operation for Statement.

  ## Parameters

    - statement: a Statement instance to remove from the database. Matches only on key data.

  ## Returns

    Statement instance of the dropped value.
  """
  def delete(%Statement{} = statement) do
    exec_delete(statement)
  end

  @doc """
  CRUD read operation for Statement.

  ## Parameters

    - (overload) statement: a Statement instance whose key values are used to find a Statement in the database.
    - (overload) statements: A list of Statement instances whose key values are used to find matching Statements in the database.
    - (overload) case_file: a CaseFile instance whose key values are used to find an associated Statement in the database.

  ## Returns

    Statement instance of the matching value or nil if a single Statement is passed.
    A list of matching Statement instances or [] if a list of Statements is passed.
  """
  def find(statements) when is_list(statements) do
    exec_find(statements)
  end

  def find(%Statement{} = statement) do
    exec_find(statement)
  end

  @doc """
  Look up Statement by its parent CaseFile.

  ## Parameters

    - (overload) case_file: a CaseFile instance whose key values are used to find an associated Statement in the database.

  ## Returns

    Statement instance of the matching value or nil if doesn't exist.
  """

  def find_by_case_file(%CaseFile{} = case_file) do
    "MATCH (s:Statement)-[:Describes]->(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN s"
    |> exec_query(empty_instance())
  end

  def find_by_case_file(%{serial_number: _serial_number} = case_file) do
    "MATCH (s:Statement)-[:Describes]->(cf:CaseFile) WHERE cf.serial_number = \"#{
      case_file.serial_number
    }\" RETURN s"
    |> exec_query(empty_instance())
  end

  def validate(%Statement{} = statement) do
    statement
  end

  defp md5(description) do
    :crypto.hash(:md5, description) |> Base.encode16()
  end
end
