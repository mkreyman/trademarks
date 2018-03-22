defmodule TrademarksWeb.V1.CaseFileView do
  use TrademarksWeb, :view
  alias TrademarksWeb.V1.CaseFileView

  def render("index.json", %{case_files: case_files}) do
    %{data: render_many(case_files, CaseFileView, "case_file.json")}
  end

  def render("show.json", %{case_file: case_file}) do
    %{data: render_one(case_file, CaseFileView, "case_file.json")}
  end

  def render("case_file.json", %{case_file: case_file}) do
    %{
      id: case_file.id,
      abandonment_date: case_file.abandonment_date,
      filing_date: case_file.filing_date,
      registration_date: case_file.registration_date,
      registration_number: case_file.registration_number,
      renewal_date: case_file.renewal_date,
      serial_number: case_file.serial_number,
      status_date: case_file.status_date
    }
  end
end
