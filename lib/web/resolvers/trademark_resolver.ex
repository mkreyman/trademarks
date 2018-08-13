defmodule Trademarks.Web.TrademarkResolver do
  alias Trademarks.Models.Nodes.Trademark

  def list_trademarks(_root, _args, _info) do
    trademarks = Trademark.list()
    {:ok, trademarks}
  end

  def search_trademark(_root, %{name: name}, _info) do
    case Trademark.search(%Trademark{name: name}) do
      nil ->
        {:error, "Trademark '#{name}' not found"}
      tm ->
        {:ok, tm}
    end
  end
end