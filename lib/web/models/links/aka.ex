defmodule Trademarks.Models.Links.Aka do
  @moduledoc """
  CRUD operations for "Aka" links between Correspondent and Attorney.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.InterfaceBase

  import UUID
  import Neo4j.LinkCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.{Attorney, Correspondent}

  defstruct [:aka_id, :label]

  @type t :: %Aka{
          aka_id: String.t(),
          label: String.t()
        }

  def object_keys() do
    [:aka_id]
  end

  def empty_instance() do
    %Aka{aka_id: uuid1(), label: struct_to_name()}
  end

  @doc """
  CRUD create operation for a Aka relationship.
  Note that this method only creates an instance, and does NOT save it to the database.

  ## Parameters

    - options: optional property settings for the new Aka node.

  ## Returns

    Aka instance to be used to join Correspondent to Attorney.
  """
  def create(options) do
    empty_instance()
    |> merge_options(options)
  end

  def link(%Attorney{} = attorney, %Correspondent{} = correspondent) do
    make(correspondent, attorney, empty_instance())
  end

  def unlink(%Attorney{} = attorney, %Correspondent{} = correspondent) do
    break(correspondent, attorney, %Aka{})
  end

  def validate(%Aka{} = aka) do
    aka
  end
end
