defmodule TrademarksWeb.V1.SearchView do
  use TrademarksWeb, :view

  def render("search.json-api", %{data: entries}) do
    %{jsonapi: %{version: "1.0"}, data: entries}
  end
end
