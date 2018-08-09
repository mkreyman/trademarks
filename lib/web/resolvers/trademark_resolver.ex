defmodule Trademarks.Web.TrademarkResolver do
  alias Trademarks.Models.Nodes.Trademark

  def trademarks(_root, _args, _info) do
    trademarks = Trademark.list()
    {:ok, trademarks}
  end

  def trademark(_root, %{name: name}, _info) do
    tm = Trademark.search(%Trademark{name: name})
    {:ok, tm}
  end
end