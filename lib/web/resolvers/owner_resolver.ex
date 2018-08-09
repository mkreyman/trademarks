defmodule Trademarks.Web.OwnerResolver do
  alias Trademarks.Models.Nodes.Owner

  def owners(_root, _args, _info) do
    owners = Owner.list()
    {:ok, owners}
  end

  def owner(_root, %{name: _name} = args, _info) do
    owners = Owner.search(args)
    {:ok, owners}
  end
end