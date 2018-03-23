defmodule TrademarksWeb.V1.AttorneyView do
  use TrademarksWeb, :view

  attributes([:name])

  has_many(
    :case_files,
    serializer: TrademarksWeb.V1.CaseFileView,
    include: false,
    identifiers: :when_included
  )

  # The render("index.json-api", data) and render("show.json-api", data)
  # are defined for us by JaSerializer.PhoenixView.

  def render("search.json-api", %{data: entries}) do
    %{data: entries}
  end
end
