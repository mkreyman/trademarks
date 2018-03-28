defmodule TrademarksWeb.V1.AttorneyView do
  use TrademarksWeb, :view

  attributes([:name])

  has_many(
    :case_files,
    serializer: TrademarksWeb.V1.CaseFileView,
    include: false,
    identifiers: :when_included
  )
end
