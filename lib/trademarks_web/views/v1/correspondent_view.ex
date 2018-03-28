defmodule TrademarksWeb.V1.CorrespondentView do
  use TrademarksWeb, :view

  attributes([
    :address_1,
    :address_2,
    :address_3,
    :address_4,
    :address_5
  ])

  has_many(
    :case_files,
    serializer: TrademarksWeb.V1.CaseFileView,
    include: false,
    identifiers: :when_included
  )
end
