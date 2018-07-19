defmodule Validators.RequiredFieldValidator do
  @moduledoc """
  """

  use ApplicationErrors.Validator
  use Util.PipeDebug

  import Util.StructUtils
  import ApplicationErrors.FieldValidator
  import ApplicationErrors

  alias ApplicationErrors.ApplicationError

  defmacro __using__(_opts) do
    quote do
      use Validators.ObjectKeyValidator

      def required_fields() do
        [] ++ object_keys()
      end

      defoverridable required_fields: 0
    end
  end

  @doc """
  Helper method to get the required fields from a given structure object.

  ## Parameters

    - object: The object for which required fields are to be returned.

  ## Returns

    - the list of required field names for the object, should include object_keys if they exist.
  """
  def required_fields(object) do
    module_for(object).required_fields()
  end

  @doc """
  Validate a struct to see if all the (unique) keys of the structure object are present.

  ## Parameters

    - object: the object to examine fot the presence (non-nil values) of required values.

  ## Returns

    - the object itself if validation succeeded.
    - ApplicationErrors if the validation failed.

  """
  def validate(object) when is_map(object) do
    object
    |> Map.from_struct()
    |> Enum.filter(fn {k, _} -> required_fields(object) |> Enum.member?(k) end)
    |> Enum.into(%{})
    |> Enum.filter(fn {_, v} -> value_missing(v) end)
    |> Enum.into(%{})
    |> Map.keys()
    |> missing_fields_check(object)
  end

  # Private

  defp missing_fields_check(missing_fields, object)
       when is_list(missing_fields) and length(missing_fields) > 0 do
    missing_fields
    |> Enum.reduce(ApplicationErrors.new(), fn field, errors ->
      add(errors, %ApplicationError{
        code: :missing_required_field,
        field: field,
        message: "#{struct_to_name(object)} has nil required value #{to_string(field)}."
      })
    end)
  end

  defp missing_fields_check(_, object) do
    object
  end
end
