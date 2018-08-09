defmodule Trademarks.Web.AddressResolver do
  alias Trademarks.Models.Nodes.Address

  def address(_root, %{address_1: address_1}, _info) do
    addr = Address.search(%Address{address_1: address_1})
    {:ok, addr}
  end
end