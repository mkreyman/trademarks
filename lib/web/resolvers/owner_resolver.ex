defmodule Trademarks.Web.OwnerResolver do
  alias Trademarks.Models.Nodes.Owner

  def list_owners(_root, _args, _info) do
    owners = Owner.list()
    {:ok, owners}
  end

  def search_owner(_root, %{name: name}, _info) do
    case Owner.search(%{name: name}) do
      nil ->
        {:error, "Owner '#{name}' not found"}
      owners ->
        {:ok, owners}
    end
  end

  def case_file_owner(case_file, _args, _info) do
    owner = Owner.find_by_case_file(case_file)
    {:ok, owner}
  end
end