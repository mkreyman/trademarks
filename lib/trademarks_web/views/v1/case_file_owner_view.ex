defmodule TrademarksWeb.V1.CaseFileOwnerView do
  use TrademarksWeb, :view

  attributes([
    :dba,
    :nationality_country,
    :nationality_state,
    :party_name,
    :address_1,
    :address_2,
    :city,
    :state,
    :postcode,
    :country
  ])

  # The render("index.json-api", data) and render("show.json-api", data)
  # are defined for us by JaSerializer.PhoenixView.

  def render("search.json-api", %{data: entries}) do
    %{data: entries}
  end
end
