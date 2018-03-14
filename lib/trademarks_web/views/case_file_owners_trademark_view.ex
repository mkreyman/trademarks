defmodule TrademarksWeb.CaseFileOwnersTrademarkView do
  use TrademarksWeb, :view
  alias TrademarksWeb.CaseFileOwnersTrademarkView

  def render("index.json", %{case_file_owners_trademarks: case_file_owners_trademarks}) do
    %{
      data:
        render_many(
          case_file_owners_trademarks,
          CaseFileOwnersTrademarkView,
          "case_file_owners_trademark.json"
        )
    }
  end

  def render("show.json", %{case_file_owners_trademark: case_file_owners_trademark}) do
    %{
      data:
        render_one(
          case_file_owners_trademark,
          CaseFileOwnersTrademarkView,
          "case_file_owners_trademark.json"
        )
    }
  end

  def render("case_file_owners_trademark.json", %{
        case_file_owners_trademark: case_file_owners_trademark
      }) do
    %{id: case_file_owners_trademark.id}
  end
end
