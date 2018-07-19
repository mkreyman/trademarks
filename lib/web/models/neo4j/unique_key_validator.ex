defmodule Neo4j.UniqueKeyValidator do
  @moduledoc """
  Allows structures to specify one or more fields as unique keys for storage/retrieval.
  """

  use ApplicationErrors.Validator
  # use Util.PipeDebug

  import Util.StructUtils
  import ApplicationErrors

  alias Neo4j.NodeCore
  alias ApplicationErrors.ApplicationError

  def validate(node) when is_map(node) do
    case NodeCore.exec_find(node) do
      nil ->
        node

      _ ->
        add(%ApplicationError{
          code: :duplicate_key,
          field: :id,
          message:
            "#{struct_to_name(node)} has duplicate key. Key set: [#{
              module_for(node).object_keys() |> Enum.join(",")
            }]."
        })
    end
  rescue
    e ->
      add(%ApplicationError{
        code: :duplicate_key,
        field: :id,
        message:
          "#{struct_to_name(node)} duplicate key check failed with database exception (#{
            e.message
          }), operation canceled."
      })
  end
end
