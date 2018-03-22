defmodule TrademarksWeb.V1.CorrespondentView do
  use TrademarksWeb, :view

  attributes [
    :address_1,
    :address_2,
    :address_3,
    :address_4,
    :address_5
  ]

  # The render("index.json-api", data) and render("show.json-api", data)
  # are defined for us by JaSerializer.PhoenixView.

  def render("search.json-api", %{data: entries}) do
    %{data: entries}
  end
end
