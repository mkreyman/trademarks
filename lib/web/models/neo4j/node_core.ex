require IEx

defmodule Neo4j.NodeCore do
  import Neo4j.Core
  import Util.StructUtils
  # import Util.PipeDebug
  import Util.InterfaceBase

  alias ApplicationErrors.Validation
  alias Neo4j.UniqueKeyValidator
  alias Validators.ObjectKeyValidator

  @moduledoc """
  Core-level capabilities for doing CRUD operations on Neo4j Nodes.
  """

  @doc """
  Creates a node in the Neo4j Database Labelled as the last portion of the given struct's Module.

  ## Parameters

    - node: A struct describing the data to be used to create the new node.
      Note that the struct's module must implement the behaviors described in the ObjectKeyValidator module.

  ## Returns

    - A node of the same type as passed, but containing the data as it was inserted into the new Neo4j node.
  """
  def exec_create(node) do
    exec_validate(node, [UniqueKeyValidator])
    |> perform_create()
  end

  @doc """
  Updates the non-key data in the described node.

  ## Parameters

    - node: A struct describing the data to be used to update the new node.
    - nil if the node identified in the update could not be found.
      Note that the struct's module must implement the behaviors described in the ObjectKeyValidator module.
      Note also that the key data will not be updated in the node, but is used only to find the node to update.

  ## Returns

    - A node of the same type as passed, but containing the data as it was changed in the Neo4j node.
  """
  def exec_update(node) do
    exec_validate(node)
    |> (fn node ->
          "MATCH (x:#{node_label(node)} {#{build_match_clause(node)}}) SET #{
            build_set_clause(node)
          } RETURN x"
        end).()
    |> exec_query(empty_instance(node))
  end

  @doc """
  This function takes two forms:
    1. If given a single node instance, it finds the node specified by the given node's key fields.
    2. If given a list of the same type of node, it finds all matching nodes for each node in the list.
  Note: Matches are made on the key fields of the node only.

  ## Parameters

    - (form 1) node: A struct describing the key(s) to be used to find the node.
    - (form 2) nodes: A list of nodes whose keys are used to find each matching node.
      Note that the struct's module must implement the behaviors described in the ObjectKeyValidator module.
      Note that only the key fields for the node will be used in the query to find the target node.

  ## Returns

    - (form 1) A node of the same type as passed, but containing the matching node found by Neo4j.
    - (form 1) nil if no matching node was found.
    - (form 2) A list of matching nodes of the type contained in the list.
    - (form 2) an enpty list if no matching nodes were found from the key list.
  """
  def exec_find(nodes) when is_list(nodes) do
    node = List.first(nodes)

    """
      MATCH (x:#{node_label(node)})
      WHERE #{nodes |> Enum.map(fn n -> build_where_clause(n) end) |> Enum.join(" OR ")}
      RETURN x
    """
    |> exec_query(empty_instance(node), :multi_row)
  end

  def exec_find(node) do
    """
      MATCH (x:#{node_label(node)} {#{build_match_clause(node)}})
      RETURN x
    """
    |> exec_query(empty_instance(node))
  end

  @doc """
    Given a single node instance, it finds the node specified by the given node's fields.

    ## Parameters

    - node: A struct describing the data to be used to find a matching node.

    ## Returns

    - A matching node of the same type as passed.
    - nil if no matching node was found.

  """
  def exec_search(node) do
    """
      MATCH (x:#{node_label(node)} {#{build_match_clause(node, :with_values)}})
      RETURN x
    """
    |> exec_query(empty_instance(node))
  end

  @doc """
  Deletes the node specified by the given node's key values.

  ## Parameters

    - node: A struct describing the key(s) to be used to delete the node.
      Note that the struct's module must implement the behaviors described in the ObjectKeyValidator module.
      Note that only the key fields for the node will be used in the query to delete the target node.

  ## Returns

    - A node of the same type as passed, but containing the data from the matching node deleted by Neo4j.
  """
  def exec_delete(node) do
    """
      MATCH (x:#{node_label(node)} {#{build_match_clause(node)}})
      DETACH DELETE x
    """
    |> exec_query(node)

    node
  end

  @doc """
  Given a node structure instance, returns the label associated with the node.

  ## Parameters

    - node: The node whose label is needed.

  ## Returns

    - The last part of the node structure's dotted module path
  """
  def node_label(link) do
    struct_to_name(link)
  end

  # Private

  # Run Neo4j validations.
  defp exec_validate(node, extra_validators \\ []) do
    case Validation.get_status(
           Validation.start(node, validators: [ObjectKeyValidator] ++ extra_validators)
         ) do
      [] -> node
      errors when is_list(errors) -> throw(errors)
      _ -> raise(RuntimeError, message: "Runaway validation")
    end
  end

  # Go aheaad and create the node if it does not already exist.
  defp perform_create(node) do
    """
      CREATE (x:#{node_label(node)} {#{build_create_clause(node)}})
      RETURN x
    """
    |> exec_query(empty_instance(node))
  end
end
