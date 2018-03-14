defmodule TrademarksWeb.CaseFileStatementController do
  use TrademarksWeb, :controller

  alias Trademarks.CaseFileStatement

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, _params) do
    case_file_statements = Trademarks.list_case_file_statements()
    render(conn, "index.json", case_file_statements: case_file_statements)
  end

  def create(conn, %{"case_file_statement" => case_file_statement_params}) do
    with {:ok, %CaseFileStatement{} = case_file_statement} <-
           Trademarks.create_case_file_statement(case_file_statement_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", case_file_statement_path(conn, :show, case_file_statement))
      |> render("show.json", case_file_statement: case_file_statement)
    end
  end

  def show(conn, %{"id" => id}) do
    case_file_statement = Trademarks.get_case_file_statement!(id)
    render(conn, "show.json", case_file_statement: case_file_statement)
  end

  def update(conn, %{"id" => id, "case_file_statement" => case_file_statement_params}) do
    case_file_statement = Trademarks.get_case_file_statement!(id)

    with {:ok, %CaseFileStatement{} = case_file_statement} <-
           Trademarks.update_case_file_statement(case_file_statement, case_file_statement_params) do
      render(conn, "show.json", case_file_statement: case_file_statement)
    end
  end

  def delete(conn, %{"id" => id}) do
    case_file_statement = Trademarks.get_case_file_statement!(id)

    with {:ok, %CaseFileStatement{}} <- Trademarks.delete_case_file_statement(case_file_statement) do
      send_resp(conn, :no_content, "")
    end
  end
end
