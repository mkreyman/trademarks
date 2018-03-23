defmodule TrademarksWeb.V1.CaseFileView do
  use TrademarksWeb, :view

  attributes([
    :abandonment_date,
    :filing_date,
    :registration_date,
    :registration_number,
    :renewal_date,
    :serial_number,
    :status_date
  ])

  has_one(
    :trademark,
    serializer: TrademarksWeb.V1.TrademarkView,
    include: true,
    identifiers: :when_included
  )

  has_many(
    :case_file_owners,
    serializer: TrademarksWeb.V1.CaseFileOwnerView,
    include: true,
    identifiers: :when_included
  )

  has_one(
    :correspondent,
    serializer: TrademarksWeb.V1.CorrespondentView,
    include: true,
    identifiers: :when_included
  )

  has_many(
    :case_file_statements,
    serializer: TrademarksWeb.V1.CaseFileStatementView,
    include: true,
    identifiers: :when_included
  )

  has_many(
    :case_file_event_statements,
    serializer: TrademarksWeb.V1.CaseFileEventStatementView,
    include: true,
    identifiers: :when_included
  )

  # The render("index.json-api", data) and render("show.json-api", data)
  # are defined for us by JaSerializer.PhoenixView.
end
