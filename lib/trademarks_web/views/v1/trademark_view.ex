defmodule TrademarksWeb.V1.TrademarkView do
  use TrademarksWeb, :view
  alias TrademarksWeb.V1.TrademarkView

  def render("index.json", %{trademarks: trademarks}) do
    %{data: render_many(trademarks, TrademarkView, "trademark.json")}
  end

  def render("show.json", %{trademark: trademark}) do
    %{data: render_one(trademark, TrademarkView, "trademark.json")}
  end

  def render("trademark.json", %{trademark: trademark}) do
    %{id: trademark.id, name: trademark.name}
  end

  def render("search.json", %{entries: entries}) do
    %{data: entries}
  end
end
