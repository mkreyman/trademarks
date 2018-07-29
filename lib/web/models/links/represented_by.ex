defmodule Trademarks.Models.Links.RepresentedBy do
  @moduledoc """
  CRUD operations for "RepresentedBy" links between Owner and Attorney.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Owner, Attorney}

  defstruct [:represented_by_id, :module]

  @type t :: %RepresentedBy{
          represented_by_id: String.t(),
          module: String.t()
        }

  def object_keys() do
    [:represented_by_id]
  end

  def empty_instance() do
    %RepresentedBy{represented_by_id: uuid1(), module: to_string(RepresentedBy)}
  end

  @doc """
  CRUD create operation for a RepresentedBy relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new RepresentedBy node.

  ## Returns

    RepresentedBy instance to be used to join Owner to Attorney
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%Owner{} = owner, %Attorney{} = attorney) do
    make(owner, attorney, empty_instance())
  end

  def unlink(%Owner{} = owner, %Attorney{} = attorney) do
    break(owner, attorney, %RepresentedBy{})
  end

  def validate(%RepresentedBy{} = represented_by) do
    represented_by
  end
end
