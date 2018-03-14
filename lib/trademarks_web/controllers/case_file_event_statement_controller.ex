defmodule TrademarksWeb.CaseFileEventStatementController do
  use TrademarksWeb, :controller

  alias Trademarks.CaseFileEventStatement

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, _params) do
    case_file_event_statements = Trademarks.list_case_file_event_statements()
    render(conn, "index.json", case_file_event_statements: case_file_event_statements)
  end

  def create(conn, %{"case_file_event_statement" => case_file_event_statement_params}) do
    with {:ok, %CaseFileEventStatement{} = case_file_event_statement} <-
           Trademarks.create_case_file_event_statement(case_file_event_statement_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        case_file_event_statement_path(conn, :show, case_file_event_statement)
      )
      |> render("show.json", case_file_event_statement: case_file_event_statement)
    end
  end

  def show(conn, %{"id" => id}) do
    case_file_event_statement = Trademarks.get_case_file_event_statement!(id)
    render(conn, "show.json", case_file_event_statement: case_file_event_statement)
  end

  def update(conn, %{"id" => id, "case_file_event_statement" => case_file_event_statement_params}) do
    case_file_event_statement = Trademarks.get_case_file_event_statement!(id)

    with {:ok, %CaseFileEventStatement{} = case_file_event_statement} <-
           Trademarks.update_case_file_event_statement(
             case_file_event_statement,
             case_file_event_statement_params
           ) do
      render(conn, "show.json", case_file_event_statement: case_file_event_statement)
    end
  end

  def delete(conn, %{"id" => id}) do
    case_file_event_statement = Trademarks.get_case_file_event_statement!(id)

    with {:ok, %CaseFileEventStatement{}} <-
           Trademarks.delete_case_file_event_statement(case_file_event_statement) do
      send_resp(conn, :no_content, "")
    end
  end
end
