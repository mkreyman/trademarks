defmodule TrademarksWeb.CaseFileOwnerView do
  use TrademarksWeb, :view
  alias TrademarksWeb.CaseFileOwnerView

  def render("index.json", %{case_file_owners: case_file_owners}) do
    %{data: render_many(case_file_owners, CaseFileOwnerView, "case_file_owner.json")}
  end

  def render("show.json", %{case_file_owner: case_file_owner}) do
    %{data: render_one(case_file_owner, CaseFileOwnerView, "case_file_owner.json")}
  end

  def render("case_file_owner.json", %{case_file_owner: case_file_owner}) do
    %{
      id: case_file_owner.id,
      dba: case_file_owner.dba,
      nationality_country: case_file_owner.nationality_country,
      nationality_state: case_file_owner.nationality_state,
      party_name: case_file_owner.party_name,
      address_1: case_file_owner.address_1,
      address_2: case_file_owner.address_2,
      city: case_file_owner.city,
      state: case_file_owner.state,
      postcode: case_file_owner.postcode,
      country: case_file_owner.country
    }
  end

  def render("search.json", %{entries: entries}) do
    %{data: entries}
  end
end
