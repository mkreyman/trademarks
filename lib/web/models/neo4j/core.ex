defmodule Neo4j.Core do
  @moduledoc """
  Core-level capabilities for doing CRUD operations on all Neo4j Objects.
  """
  use Util.PipeDebug

  import Util.StructUtils
  # import Util.PipeDebug

  @neo4j_interface Bolt.Sips

  @doc """
  Build the MATCH clause for a Neo4j query operation.

  ## Parameters

    - structure: the struct (node or link) to build the MATCH clause for. Contains the names and values for
      for each property to be updated.
    - fields: a type of fields to match, in [:all_fields, :non_uuid, :keys_only, :non_keys, :with_values].

  ## Returns

    - A string representing the property assignments to be used in a Neo4j MATCH clause.
  """
  def build_match_clause(structure, fields \\ :keys_only) do
    structure
    |> get_fields(fields)
    |> build_param_string
  end

  @doc """
  Build the CREATE clause for a Neo4j query operation.

  ## Parameters

    - structure: the struct (node or link) to build the CREATE clause for. Contains the names and values
      for each property to be updated.

  ## Returns

    - A string representing the property assignments to be used in a Neo4j CREATE clause.
  """
  def build_create_clause(structure) do
    structure
    |> get_fields(:all_fields)
    |> build_param_string
  end

  @doc """
  Build the SET clause for a Neo4j update operation.

  ## Parameters

    - structure: the struct (node or link) to build the update SET clause for. Contains the names and values for
      for each property to be updated.
    - var: short name used in the Neo4j MATCH clause for the update.

  ## Returns

    - A string representing the property assignments to be used in a Neo4j SET clause.
  """
  def build_set_clause(structure, var \\ "x") do
    structure
    |> get_fields(:non_keys)
    |> build_param_string(" = ", ", ", var <> ".")
  end

  @doc """
  Build the WHERE clause for a Neo4j query.

  ## Parameters

    - structure: the struct (node or link) to build the WHERE clause for. Contains the names and values for
      for the key values to be used in the WHERE clause.
    - var: short name used in the Neo4j MATCH clause for the query.

  ## Returns

    - A string representing the "AND"-joined WHERE clause values.
  """
  def build_where_clause(structure, var \\ "x") do
    "(#{
      structure
      |> get_fields(:keys_only)
      |> build_param_string(" = ", " AND ", var <> ".")
    })"
  end

  @doc """
  Make the call to execute an operation on the Neo4j server.

  ## Parameters

    - cypher: The cypher operation to perform.
    - structure: A structure in which to return the operation results in.
    - format: An atom in the set [ :single_row, :multi_row ] describing whether a single or multi-row result is
      expected as the result.

  ## Returns

    - A value appropriate to the results of the operation (populated structure(s) or nil).
  """
  def exec_query(cypher, structure \\ nil, format \\ :single_row) do
    cypher
    |> exec_raw()
    |> to_result_set(structure, format)
  end

  @doc """
  Execute a Neo4j query and allow the caller to interpret the resulting raw data.

  ## Parameters

    - cypher: The cypher query to perform.

  ## Returns

    - A raw data structure whose interpretation is dependent on the query made by the caller.

  ## Raises

    - Neo4j.Exception: if the cypher query results in an error.
  """
  def exec_raw(cypher) do
    cypher =
      cypher
      |> String.replace("\n", " ")

    conn = @neo4j_interface.conn

    case @neo4j_interface.query(conn, cypher) do
      {:ok, result} -> result
      {:error, message} -> raise(Neo4j.Exception, message)
    end
  end

  @doc """
  Convert a value into a cypher-ready string format. Converts strings into strings surrounded with quotes, nils into
  "null", lists into comma-separated values and leaves other values alone.

  Note that the list version causes a recursive call to cypher_prep to convert the values in the list.

  ## Parameters

    - value: the value to make cypher string-ready.

  ## Returns

    - a string ready to be dropped as-is into
  """
  def cypher_prep(value) when is_list(value) do
    string =
      value
      |> Enum.map(fn v -> cypher_prep(v) end)
      |> Enum.join(", ")

    "[ #{string} ]"
  end

  def cypher_prep(value) when is_nil(value) do
    "null"
  end

  def cypher_prep(value) when is_binary(value) do
    "\"#{value}\""
  end

  def cypher_prep(value), do: "#{value}"

  @doc """
  Return today's date as an integer in the form YYYYMMDD
  """
  @spec neo_today() :: integer()
  def neo_today do
    Date.utc_today()
    |> to_neo_date()
  end

  @doc """
  Return the specified date as an integer in the form YYYYMMDD
  """
  @spec to_neo_date(Date.t() | DateTime.t()) :: integer()
  def to_neo_date(date) do
    date
    |> Date.to_iso8601(:basic)
    |> String.to_integer()
  end

  @doc """
  Convert a Neo date (integer in the form YYYYMMDD) to a String in the form "YYYY-MM-DD"
  """
  @spec neo_date_to_string(integer()) :: binary()
  def neo_date_to_string(date) do
    date
    |> neo_date_to_date()
    |> Date.to_string()
  end

  @doc """
  Convert a Neo date (integer in the form YYYYMMDD) to an Elixir Date struct.
  """
  @spec neo_date_to_date(integer()) :: Date.t()
  def neo_date_to_date(date) do
    Date.new(div(date, 10_000), date |> rem(10_000) |> div(100), rem(date, 100))
  end

  # PRIVATE

  # Result set interpretation...
  defp to_result_set(_neo_results, structure, _format) when is_nil(structure) do
    nil
  end

  defp to_result_set(neo_results, structure, :multi_row) do
    neo_results |> Enum.map(fn nr -> nr |> to_record(structure) end)
  end

  defp to_result_set(neo_results, structure, :single_row) do
    cond do
      Enum.count(neo_results) <= 1 ->
        neo_results
        |> List.first()
        |> to_record(structure)

      # The caller may have wanted a single result, but got multiple rows: process as a multi-row result.
      true ->
        to_result_set(neo_results, structure, :multi_row)
    end
  end

  defp to_record(neo_set, _structure) when is_nil(neo_set) do
    nil
  end

  defp to_record(neo_set, structure) when is_map(neo_set) do
    neo_set
    |> Map.values()
    |> List.first()
    |> structify(structure)
  end

  defp to_record(_neo_set, _structure) do
    nil
  end

  # Query construction...
  defp build_param_string(structure, operator \\ ":", joiner \\ ", ", var \\ "") do
    structure
    |> Map.keys()
    |> List.delete(:id)
    |> Enum.map(fn k ->
      "#{var}#{Atom.to_string(k)}#{operator}#{cypher_prep(Map.fetch!(structure, k))}"
    end)
    |> Enum.join(joiner)
  end

  defp get_fields(structure, :all_fields) do
    structure
    |> Map.from_struct()
  end

  defp get_fields(structure, :non_uuid) do
    structure
    |> get_fields(:all_fields)
    |> Enum.reject(fn {_, v} -> is_uuid(v) end)
    |> Enum.into(%{})
  end

  defp get_fields(structure, :keys_only) do
    structure
    |> get_fields(:all_fields)
    |> Enum.filter(fn {k, _} ->
      Map.fetch!(structure, :__struct__).object_keys() |> Enum.member?(k)
    end)
    |> Enum.into(%{})
  end

  defp get_fields(structure, :non_keys) do
    structure
    |> get_fields(:all_fields)
    |> Enum.filter(fn {k, _} ->
      !(Map.fetch!(structure, :__struct__).object_keys() |> Enum.member?(k))
    end)
    |> Enum.into(%{})
  end

  defp get_fields(structure, :with_values) do
    structure
    |> get_fields(:non_uuid)
    |> Enum.reject(fn {_, v} -> v in [nil, false] end)
    |> Enum.into(%{})
  end

  defp is_uuid(string) do
    case UUID.info(string) do
      {:ok, _} -> true
      _ -> false
    end
  end
end
