defmodule ApplicationErrors do
  use Util.PipeDebug

  defmodule ApplicationError do
    import Util.InterfaceBase
    alias __MODULE__, warn: false

    defstruct code: nil,
              field: nil,
              message: nil

    @type t :: %ApplicationError{
            code: String.t() | atom(),
            field: String.t() | atom(),
            message: String.t()
          }

    def new(options) do
      merge_options(%ApplicationError{}, options)
    end
  end

  @type t :: {:errors, [ApplicationError]}

  @doc """
  Start a new, empty ApplicationErrors set.

  Synonymous with add().

  ## Parameters

    - none

  ## Returns

    - an empty ApplicationErrors set.
  """
  @spec new() :: ApplicationErrors
  def new() do
    add()
  end

  @doc """
    Add ApplicationError(s) to an ApplicationErrors set, creating a new one, if necessary.

    ## Parameters

      - (varies):
        - ApplicationErrors - a set of errors to add ApplicationError instances to or combine with.
        - [ApplicationError] - a collection of ApplicationError structures.
        - ApplicationError - a single instance of ApplicationError.
        - options - the fields of the ApplicationError structure, used to construct a new, single instance.
          - :code - An error code.  Tags (atoms) are preferred over meaningless numbers.
          - :field - The field in a structure where the error occurred (if known).
          - :message - A meaningful error message describing the ApplicationError.

    ## Returns

      - An ApplicationErrors set in all cases.
  """
  # Start a new list.
  @spec add() :: ApplicationErrors
  def add() do
    {:errors, []}
  end

  # Combine ApplicationErrors with multiple ApplicationErrors (multiple implementations)...
  @spec add(ApplicationErrors, ApplicationErrors) :: ApplicationErrors
  def add({:errors, a}, {:errors, b}) do
    {:errors, a ++ b}
  end

  # Add a single error (multiple implementations)...
  @spec add(ApplicationErrors, ApplicationError) :: ApplicationErrors
  def add({:errors, previous}, %ApplicationError{} = error) do
    {:errors, previous ++ [error]}
  end

  @spec add(ApplicationError) :: ApplicationErrors
  def add(%ApplicationError{} = error) do
    {:errors, [error]}
  end

  def is_errors(object) do
    is_tuple(object) && elem(object, 0) == :errors && is_list(elem(object, 1))
  end
end
