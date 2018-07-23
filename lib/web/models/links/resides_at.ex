defmodule Trademarks.Models.Links.ResidesAt do
  @moduledoc """
  CRUD operations for "ResidesAt" links between Address and Owner.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Address, Owner}

  defstruct [:resides_at_id]

  @type t :: %ResidesAt{resides_at_id: String.t()}

  def object_keys() do
    [:resides_at_id]
  end

  def empty_instance() do
    %ResidesAt{resides_at_id: uuid1()}
  end

  @doc """
  CRUD create operation for a ResidesAt relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new ResidesAt node.

  ## Returns

    ResidesAt instance to be used to join Address to Owner.
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%Owner{} = owner, %Address{} = address) do
    make(owner, address, empty_instance())
  end

  def unlink(%Owner{} = owner, %Address{} = address) do
    break(owner, address, %ResidesAt{})
  end

  def validate(%ResidesAt{} = resides_at) do
    resides_at
  end
end
