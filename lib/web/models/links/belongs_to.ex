defmodule Trademarks.Models.Links.BelongsTo do
  @moduledoc """
  CRUD operations for "BelongsTo" links between Trademark and its Owner.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  # import Neo4j.Core
  import Neo4j.LinkCore
  # import Neo4j.NodeCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Owner, Trademark}

  defstruct [:belongs_to_id]

  @type t :: %BelongsTo{belongs_to_id: String.t()}

  def object_keys() do
    [:belongs_to_id]
  end

  def empty_instance() do
    %BelongsTo{belongs_to_id: uuid1()}
  end

  @doc """
  CRUD create operation for a BelongsTo relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new BelongsTo node.

  ## Returns

    BelongsTo instance to be used to join Trademark to Owner
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%Trademark{} = trademark, %Owner{} = owner) do
    make(trademark, owner, empty_instance())
  end

  def unlink(%Trademark{} = trademark, %Owner{} = owner) do
    break(trademark, owner, %BelongsTo{})
  end

  def validate(%BelongsTo{} = belongs_to) do
    belongs_to
  end
end
