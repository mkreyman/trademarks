defmodule TrademarksWeb.SearchView do
  use TrademarksWeb, :view

  def render("search.json", %{entries: entries}) do
    %{data: entries}
  end
end
