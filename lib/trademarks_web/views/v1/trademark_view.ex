defmodule TrademarksWeb.V1.TrademarkView do
  use TrademarksWeb, :view

  attributes [:name]

  # The render("index.json-api", data) and render("show.json-api", data)
  # are defined for us by JaSerializer.PhoenixView.

  def render("search.json-api", %{data: entries}) do
    %{data: entries}
  end
end
