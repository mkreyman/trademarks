defmodule Trademarks.Models.Links.Locates do
  @moduledoc """
  CRUD operations for "Locates" links between Address and Owner.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Address, Owner}

  defstruct [:locates_id]

  @type t :: %Locates{locates_id: String.t()}

  def object_keys() do
    [:locates_id]
  end

  def empty_instance() do
    %Locates{locates_id: uuid1()}
  end

  @doc """
  CRUD create operation for a Locates relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new Locates node.

  ## Returns

    Locates instance to be used to join Address to Owner.
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%Address{} = address, %Owner{} = owner) do
    make(address, owner, empty_instance())
  end

  def unlink(%Address{} = address, %Owner{} = owner) do
    break(address, owner, %Locates{})
  end

  def validate(%Locates{} = locates) do
    locates
  end
end
