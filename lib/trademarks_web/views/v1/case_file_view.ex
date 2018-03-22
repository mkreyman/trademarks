defmodule TrademarksWeb.V1.CaseFileView do
  use TrademarksWeb, :view

  attributes [
    :abandonment_date,
    :filing_date,
    :registration_date,
    :registration_number,
    :renewal_date,
    :serial_number,
    :status_date
  ]

  # The render("index.json-api", data) and render("show.json-api", data)
  # are defined for us by JaSerializer.PhoenixView.
end
