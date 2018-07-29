defmodule Trademarks.Models.Links.Owns do
  @moduledoc """
  CRUD operations for "Owns" links between Owner and Trademark.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Owner, Trademark}

  defstruct [:owns_id, :module]

  @type t :: %Owns{
          owns_id: String.t(),
          module: String.t()
        }

  def object_keys() do
    [:owns_id]
  end

  def empty_instance() do
    %Owns{owns_id: uuid1(), module: to_string(Owns)}
  end

  @doc """
  CRUD create operation for a Owns relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new Owns node.

  ## Returns

    Owns instance to be used to join Owner to Trademark.
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%Owner{} = owner, %Trademark{} = trademark) do
    make(owner, trademark, empty_instance())
  end

  def unlink(%Owner{} = owner, %Trademark{} = trademark) do
    break(owner, trademark, %Owns{})
  end

  def validate(%Owns{} = owns) do
    owns
  end
end
