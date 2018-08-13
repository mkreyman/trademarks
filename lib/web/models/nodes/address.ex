defmodule Trademarks.Models.Nodes.Address do
  @moduledoc """
  CRUD operations for Address nodes.
  """

  use Util.StructUtils
  use Util.PipeDebug

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
    :label,
    :hash,
    :module
  ]

  @type t :: %Address{
          address_1: String.t(),
          address_2: String.t(),
          city: String.t(),
          state: String.t(),
          postcode: String.t(),
          country: String.t(),
          label: String.t(),
          hash: String.t(),
          module: String.t()
        }

  def object_keys() do
    [:address_1, :hash]
  end

  def empty_instance() do
    %Address{label: struct_to_name(), module: to_string(__MODULE__)}
  end

  def list() do
    exec_list(__MODULE__.__struct__)
  end

  @doc """
  CRUD create operation for Address.

  ## Parameters

    - address: a Address instance to store in the database.

  ## Returns

    Address instance of the stored value.
  """
  def create(%Address{address_1: nil, address_2: nil} = address) do
    address
    |> struct(label: struct_to_name())
    |> exec_create()
  end

  def create(%Address{address_1: "", address_2: address_2} = address)
      when byte_size(address_2) != 0 do
    %{address | address_1: address_2, address_2: nil}
    |> create()
  end

  def create(%Address{address_1: address_1} = address) do
    address_1 =
      address_1
      |> String.replace("\"", "'")

    """
      MERGE (a:Address {hash: apoc.util.md5([UPPER(\"#{address_1}\"),
                                             UPPER(\"#{address.address_2}\"),
                                             UPPER(\"#{address.city}\"),
                                             UPPER(\"#{address.state}\"),
                                             \"#{address.postcode}\",
                                             UPPER(\"#{address.country}\")])})
      ON CREATE SET a.address_1 = UPPER(\"#{address_1}\"),
                    a.address_2 = UPPER(\"#{address.address_2}\"),
                    a.city = UPPER(\"#{address.city}\"),
                    a.state = UPPER(\"#{address.state}\"),
                    a.postcode = \"#{address.postcode}\",
                    a.country = UPPER(\"#{address.country}\"),
                    a.label = \"#{struct_to_name()}\",
                    a.module = \"#{to_string(__MODULE__)}\"
      RETURN a
    """
    |> String.replace("\n", " ")
    |> exec_query(%Address{})
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
    "MATCH (o:Owner)-[:RESIDES_AT]->(a:Address) WHERE o.name = \"#{owner.name}\" RETURN a"
    |> exec_query(empty_instance())
  end

  def find_by_owner(%{name: _name} = owner) do
    "MATCH (o:Owner)-[:RESIDES_AT]->(a:Address) WHERE o.name = \"#{owner.name}\" RETURN a"
    |> exec_query(empty_instance())
  end

  def validate(%Address{} = address) do
    address
  end
end
