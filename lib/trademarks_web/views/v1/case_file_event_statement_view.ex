defmodule TrademarksWeb.V1.CaseFileEventStatementView do
  use TrademarksWeb, :view

  attributes([
    :code,
    :date,
    :description,
    :event_type
  ])
end
