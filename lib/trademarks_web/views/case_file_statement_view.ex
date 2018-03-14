defmodule TrademarksWeb.CaseFileStatementView do
  use TrademarksWeb, :view
  alias TrademarksWeb.CaseFileStatementView

  def render("index.json", %{case_file_statements: case_file_statements}) do
    %{data: render_many(case_file_statements, CaseFileStatementView, "case_file_statement.json")}
  end

  def render("show.json", %{case_file_statement: case_file_statement}) do
    %{data: render_one(case_file_statement, CaseFileStatementView, "case_file_statement.json")}
  end

  def render("case_file_statement.json", %{case_file_statement: case_file_statement}) do
    %{
      id: case_file_statement.id,
      description: case_file_statement.description,
      type_code: case_file_statement.type_code
    }
  end
end
