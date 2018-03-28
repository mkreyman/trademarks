defmodule TrademarksWeb.V1.TrademarkView do
  use TrademarksWeb, :view

  attributes([:name])

  has_many(
    :case_files,
    serializer: TrademarksWeb.V1.CaseFileView,
    include: false,
    identifiers: :when_included
  )

  has_many(
    :case_file_owners,
    serializer: TrademarksWeb.V1.CaseFileOwnerView,
    include: false,
    identifiers: :when_included
  )

  has_many(
    :trademarks,
    serializer: TrademarksWeb.V1.TrademarkView,
    include: false,
    identifiers: :when_included
  )

  # The render("index.json-api", data) and render("show.json-api", data)
  # are defined for us by JaSerializer.PhoenixView.
end
