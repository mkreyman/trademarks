defmodule TrademarksWeb.V1.CaseFileOwnerView do
  use TrademarksWeb, :view

  attributes([
    :dba,
    :nationality_country,
    :nationality_state,
    :name,
    :address_1,
    :address_2,
    :city,
    :state,
    :postcode,
    :country
  ])

  has_many(
    :case_files,
    serializer: TrademarksWeb.V1.CaseFileView,
    include: false,
    identifiers: :when_included
  )
end
