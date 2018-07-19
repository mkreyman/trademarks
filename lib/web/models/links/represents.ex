defmodule Trademarks.Models.Links.Represents do
  @moduledoc """
  CRUD operations for "Represents" links between Attorney and Owner.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Attorney, Owner}

  defstruct [:represents_id]

  @type t :: %Represents{represents_id: String.t()}

  def object_keys() do
    [:represents_id]
  end

  def empty_instance() do
    %Represents{represents_id: uuid1()}
  end

  @doc """
  CRUD create operation for a Represents relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new Represents node.

  ## Returns

    Represents instance to be used to join Attorney to Owner
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%Owner{} = owner, %Attorney{} = attorney) do
    make(attorney, owner, empty_instance())
  end

  def unlink(%Owner{} = owner, %Attorney{} = attorney) do
    break(attorney, owner, %Represents{})
  end

  def validate(%Represents{} = represents) do
    represents
  end
end
