defmodule Trademarks.Web.AddressResolver do
  alias Trademarks.Models.Nodes.Address

  def search_address(_root, %{address_1: address_1}, _info) do
    address = Address.search(%Address{address_1: address_1})
    {:ok, address}
  end

  def owner_address(owner, _args, _info) do
    address = Address.find_by_owner(owner)
    {:ok, address}
  end
end