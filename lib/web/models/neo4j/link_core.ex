defmodule Neo4j.LinkCore do
  import Neo4j.Core
  import Neo4j.NodeCore
  import Util.StructUtils

  @moduledoc """
  Core-level capabilities for doing CRUD operations on Neo4j Links.

  For the purposes of Trademarks, only create and delete are necessary for relationships.
  """

  @doc """
  Creates a link in the Neo4j Database Labelled as the last portion of the given link's Module between the source
  (relationship parent) and target (relationship child) nodes.

  ## Parameters

    - from: A parent node struct describing the data to be used to create the new link.
      Note that the struct's module must implement the behaviors described in the Validators.ObjectKeyValidator module.
    - to: A child node struct describing the data to be used to create the new link.
      Note that the struct's module must implement the behaviors described in the Validators.ObjectKeyValidator module.
    - link: link structure instance for generating the link label.

  ## Returns

    - The newly created link if created successfully
    - nil if the link already exists or either of the specified nodes is missing.
  """
  def make(from, to, link) do
    case [exec_find(from), exec_find(to)] |> Enum.any?(fn node -> is_nil(node) end) do
      false -> from |> seek(to, link) |> create_link(from, to, link)
      true -> nil
    end
  end

  @doc """
  Destroys a link of the given type between a specified source and target node.

  ## Parameters

    - from: A parent node struct describing the parent node of the link to destroy.
      Note that the struct's module must implement the behaviors described in the Validators.ObjectKeyValidator module.
    - to: A child node struct describing the child node of the link to destroy.
      Note that the struct's module must implement the behaviors described in the Validators.ObjectKeyValidator module.
    - link: link structure instance to identify the link label (type of link) to delete.
      Note: if link is not passed, all single-hop links between the specified nodes will be deleted.

  ## Returns

    - nil
  """
  def break(from, to) do
    """
      MATCH path=(a:#{node_label(from)}
        {#{build_match_clause(from)}})-[*1..1]-(b:#{node_label(to)}
        {#{build_match_clause(to)}})
      WITH rels(path) AS rels
      UNWIND rels AS rel
      WITH DISTINCT rel
      DELETE rel
    """
    |> exec_query()
  end

  def break(from, to, link) do
    """
      MATCH (a:#{node_label(from)}
        {#{build_match_clause(from)}})-[r:#{link_label(link)}]-(b:#{node_label(to)}
        {#{build_match_clause(to)}})
      DELETE r
    """
    |> exec_query(empty_instance(link))
  end

  @doc """
  Find the existing link between the two specified nodes (if any)

  ## Parameters

    - from: A parent node struct describing the parent node of the link to find.
      Note that the struct's module must implement the behaviors described in the Validators.ObjectKeyValidator module.
    - to: A child node struct describing the child node of the link to find.
      Note that the struct's module must implement the behaviors described in the Validators.ObjectKeyValidator module.
    - link: link structure instance to identify the link label (type of link) to find.

  ## Returns

    - A link object representing the existing link between nodes if one of the specified type exists.
    - nil if there is no such existing link.
  """
  def seek(from, to, link) do
    """
      MATCH (a:#{node_label(from)} {#{build_match_clause(from)}}), (b:#{node_label(to)} {#{
      build_match_clause(to)
    }})
      OPTIONAL MATCH (a)-[r:#{link_label(link)}]-(b)
      RETURN r
    """
    |> exec_query(empty_instance(link))
  end

  @doc """
  Given a link structure instance, returns the label associated with the link.

  ## Parameters

    - link: The link whose label is needed.

  ## Returns

    - The last part of the link structure's dotted module path
  """
  def link_label(link) do
    struct_to_name(link)
    |> Macro.underscore()
    |> String.upcase()
  end

  # Private

  defp create_link(existing, from, to, link) when is_nil(existing) do
    """
      MATCH (a:#{node_label(from)}), (b:#{node_label(to)})
      WHERE #{build_where_clause(from, "a")} AND #{build_where_clause(to, "b")}
      CREATE (a)-[r:#{link_label(link)} {#{build_create_clause(link)}}]->(b)
      RETURN r
    """
    |> exec_query(empty_instance(link))
  end

  defp create_link(_existing, _from, _to, _link) do
    nil
  end
end
