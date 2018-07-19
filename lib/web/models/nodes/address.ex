defmodule Trademarks.Models.Nodes.Address do
  @moduledoc """
  CRUD operations for Address nodes.
  """

  use Util.StructUtils

  # import UUID
  import Neo4j.Core, only: [exec_query: 2]
  import Neo4j.NodeCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.Owner

  defstruct [
    :address_1,
    :address_2,
    :city,
    :state,
    :postcode,
    :country,
    :label
  ]

  @type t :: %Address{
          address_1: String.t(),
          address_2: String.t(),
          city: String.t(),
          state: String.t(),
          postcode: String.t(),
          country: String.t(),
          label: String.t()
        }

  def object_keys() do
    [:address_1]
  end

  def empty_instance() do
    %Address{label: struct_to_name()}
  end

  @doc """
  CRUD create operation for Address.

  ## Parameters

    - address: a Address instance to store in the database.

  ## Returns

    Address instance of the stored value.
  """
  def create(%Address{address_1: address_1} = address) when is_nil(address_1) do
    address
    |> struct(label: struct_to_name())
    |> exec_create()
  end

  def create(%Address{address_1: address_1} = address) do
    %{address | address_1: String.upcase(address_1), label: struct_to_name()}
    |> exec_create()
  end

  @doc """
    Search operation for Addresses

    ## Parameters

      - address: a Address instance with fields to use to search for matching instances in the database.

    ## Returns

      - A list of matching Address instances.
  """
  def search(%Address{} = address) do
    exec_search(address)
  end

  @doc """
    Combines find and create operations for Addresses

    ## Parameters

      - address: an Address instance with key data to use to find the instance in the database.

    ## Returns

      - Address instance that was found or created.
  """
  def find_or_create(%Address{} = address) do
    case search(address) do
      %Address{} = address -> address
      nil -> create(address)
    end
  end

  @doc """
  CRUD update operation for Address.
  Note that the key data for the Address will not be updated! It is used only to update non-key fields.  To replace a
  Address's key fields, delete and recreate the Address.

  ## Parameters

    - address: a Address instance to update in the database.

  ## Returns

    Address instance of the updated value.
  """
  def update(%Address{} = address) do
    exec_update(address)
  end

  @doc """
  CRUD delete operation for Address.

  ## Parameters

    - address: a Address instance to remove from the database. Matches only on key data.

  ## Returns

    Address instance of the dropped value.
  """
  def delete(%Address{} = address) do
    exec_delete(address)
  end

  @doc """
  CRUD read operation for Address.

  ## Parameters

    - (overload) address: a Address instance whose key values are used to find an Address in the database.
    - (overload) addresses: A list of Address instances whose key values are used to find matching Addresss in the database.
    - (overload) owner: a Owner instance whose key values are used to find an associated Address in the database.

  ## Returns

    Address instance of the matching value or nil if a single Address is passed.
    A list of matching Address instances or [] if a list of Addresss is passed.
  """
  def find(addresses) when is_list(addresses) do
    exec_find(addresses)
  end

  def find(%Address{} = address) do
    exec_find(address)
  end

  @doc """
  Look up Address by its parent Owner.

  ## Parameters

    - (overload) owner: a Owner instance whose key values are used to find an associated Address in the database.

  ## Returns

    Address instance of the matching value or nil if doesn't exist.
  """

  def find_by_owner(%Owner{} = owner) do
    "MATCH (addr:Address)-[:Locates]->(o:Owner) WHERE o.name = \"#{owner.name}\" RETURN addr"
    |> exec_query(empty_instance())
  end

  def find_by_owner(%{name: _name} = owner) do
    "MATCH (addr:Address)-[:Locates]->(o:Owner) WHERE o.name = \"#{owner.name}\" RETURN addr"
    |> exec_query(empty_instance())
  end

  def validate(%Address{} = address) do
    address
  end
end
