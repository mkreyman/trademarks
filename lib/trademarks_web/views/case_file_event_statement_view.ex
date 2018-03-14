defmodule TrademarksWeb.CaseFileEventStatementView do
  use TrademarksWeb, :view
  alias TrademarksWeb.CaseFileEventStatementView

  def render("index.json", %{case_file_event_statements: case_file_event_statements}) do
    %{
      data:
        render_many(
          case_file_event_statements,
          CaseFileEventStatementView,
          "case_file_event_statement.json"
        )
    }
  end

  def render("show.json", %{case_file_event_statement: case_file_event_statement}) do
    %{
      data:
        render_one(
          case_file_event_statement,
          CaseFileEventStatementView,
          "case_file_event_statement.json"
        )
    }
  end

  def render("case_file_event_statement.json", %{
        case_file_event_statement: case_file_event_statement
      }) do
    %{
      id: case_file_event_statement.id,
      code: case_file_event_statement.code,
      date: case_file_event_statement.date,
      description: case_file_event_statement.description,
      type: case_file_event_statement.type
    }
  end
end
