defmodule ApplicationErrors.Validator do
  @moduledoc """
  """

  defmacro __using__(_opts) do
    quote do
      import ApplicationErrors
      import ApplicationErrors.Validator

      @doc """
      Validate the given object, returning ApplicationErrors if it fails.

      ## Parameters

        - object: the object to validate.

      ## Returns

        - one of:
          - object: the original object, having passed validations.
          - failures: ApplicationErrors if any validations failed.
      """
      @spec validate(any()) :: ApplicationErrors | any()
      def validate(object) do
        object
      end

      defoverridable validate: 1
    end
  end
end
