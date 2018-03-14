defmodule TrademarksWeb.CaseFilesCaseFileOwnerView do
  use TrademarksWeb, :view
  alias TrademarksWeb.CaseFilesCaseFileOwnerView

  def render("index.json", %{case_files_case_file_owners: case_files_case_file_owners}) do
    %{
      data:
        render_many(
          case_files_case_file_owners,
          CaseFilesCaseFileOwnerView,
          "case_files_case_file_owner.json"
        )
    }
  end

  def render("show.json", %{case_files_case_file_owner: case_files_case_file_owner}) do
    %{
      data:
        render_one(
          case_files_case_file_owner,
          CaseFilesCaseFileOwnerView,
          "case_files_case_file_owner.json"
        )
    }
  end

  def render("case_files_case_file_owner.json", %{
        case_files_case_file_owner: case_files_case_file_owner
      }) do
    %{id: case_files_case_file_owner.id}
  end
end
