defmodule Validators.ObjectKeyValidator do
  @moduledoc """
  Allows structures to specify one or more fields as unique keys for storage/retrieval.
  """

  use ApplicationErrors.Validator
  use Util.PipeDebug

  import Util.StructUtils
  import ApplicationErrors.FieldValidator
  import ApplicationErrors

  alias ApplicationErrors.ApplicationError

  defmacro __using__(_opts) do
    quote do
      def object_keys() do
        []
      end

      defoverridable object_keys: 0
    end
  end

  @doc """
  Helper method to get the object keys from a structure object.

  ## Parameters

    - object: The object for which (unique) key fields are to be returned.

  ## Returns

    - the list of key field names for the object.

  """
  def object_keys(node) do
    module_for(node).object_keys()
  end

  @doc """
  Validate a struct to see if all the (unique) keys of the structure object are present.

  ## Parameters

    - object: the object to examine fot the presence (non-nil values) of unique key values.

  ## Returns

    - the object itself if validation succeeded.
    - ApplicationErrors if the validation failed.

  """
  def validate(node) when is_map(node) do
    node
    |> Map.from_struct()
    |> Enum.filter(fn {k, _} -> object_keys(node) |> Enum.member?(k) end)
    |> Enum.into(%{})
    |> Enum.filter(fn {_, v} -> is_nil(v) end)
    |> Enum.into(%{})
    |> Map.keys()
    |> missing_keys_check(node)
  end

  # Private

  defp missing_keys_check(missing_keys, node)
       when is_list(missing_keys) and length(missing_keys) > 0 do
    missing_keys
    |> Enum.reduce(ApplicationErrors.new(), fn key, errors ->
      add(errors, %ApplicationError{
        code: :missing_key_field,
        field: key,
        message: "#{struct_to_name(node)} has nil key value #{to_string(key)}."
      })
    end)
  end

  defp missing_keys_check(_, node) do
    node
  end
end
