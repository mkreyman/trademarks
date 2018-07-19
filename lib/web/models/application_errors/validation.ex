defmodule ApplicationErrors.Validation do
  @moduledoc """
  Iterate over the list of Validators to apply to an object, accumulating errors or passing the object as ok.
  Could be wired into GenServer pretty easily... hint, hint.
  """

  use Agent
  use Util.PipeDebug

  alias __MODULE__, warn: false

  import ApplicationErrors

  ## Client API

  @doc """
  Starts an Agent to process validations. Creates `state` with {object, ApplicationErrors, validators}.

  ## Parameters

    - object: The trademarks object
    - opts:   Optional parameter to add validators when starting the Agent

  ## Returns

    - validation: If all of the validations are successfully proccessed.
    - nil: If process_validations threw an exception
  """
  @spec start(any(), keyword()) :: pid | nil
  def start(object, opts \\ []) do
    #    debug(object, "This is in debug for start ")
    state = {object, ApplicationErrors.new(), opts[:validators] || []}

    case Agent.start_link(fn -> state end) do
      {:ok, validation} ->
        process_validations(validation)
        validation

      _ ->
        nil
    end
  end

  @doc """
  Returns the ApplicaitonErrors for the given state object.

  ## Parameters

    - validation: The valdiation object.

  ## Returns

    - [ApplicationErrors]: If any validations failed.
    - nil: If ApplicationErrors does not exist (should not happen)
  """
  @spec get_status(pid) :: [keyword()] | nil
  def get_status(validation) do
    #    debug(validation, "This is in a debug get_status ")
    Agent.get(validation, fn {_object, errors, validators} ->
      (validators == [] && elem(errors, 1)) || nil
    end)

    #    {:ok} = Agent.stop(validation)
  end

  @doc """
  Adds a validator to the validation object, returning the validator

  ## Parameters

    - validation: The validation object
    - validator:  The validator that you wish to run on the valation object. ie (JSON Schema)

  ## Returns

    - validation: The validation object after process_validations has been called.
  """
  @spec add_validator(pid, keyword()) :: any()
  def add_validator(validation, validator) do
    #    debug(validation, "This is in a debug for add_validator ")
    Agent.update(validation, fn {object, errors, validators} ->
      {
        object,
        errors,
        # |> debug("in update ")
        validators ++ [validator]
      }
    end)

    # |> debug("at the end of the add_validator ")
    process_validations(validation)
  end

  # PRIVATE

  defp process_validations(validation) do
    #    debug(validation, "does this get called? ")
    Agent.update(validation, fn {object, errors, validators} = state ->
      {object,
       Enum.map(validators, fn validator -> process(object, validator) end)
       |> Enum.filter(fn result -> ApplicationErrors.is_errors(result) end)
       |> Enum.reduce(errors, fn result, all_errors ->
         ApplicationErrors.add(all_errors, result)
       end), []}
    end)
  end

  defp process(object, validator) when is_function(validator) do
    validator.(object)
  end

  defp process(object, validator) when is_atom(validator) do
    validator.validate(object)
  end
end
