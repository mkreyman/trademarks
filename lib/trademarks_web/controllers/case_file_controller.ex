defmodule TrademarksWeb.CaseFileController do
  use TrademarksWeb, :controller

  alias Trademarks.CaseFile

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, _params) do
    case_files = Trademarks.list_case_files()
    render(conn, "index.json", case_files: case_files)
  end

  def create(conn, %{"case_file" => case_file_params}) do
    with {:ok, %CaseFile{} = case_file} <- Trademarks.create_case_file(case_file_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", case_file_path(conn, :show, case_file))
      |> render("show.json", case_file: case_file)
    end
  end

  def show(conn, %{"id" => id}) do
    case_file = Trademarks.get_case_file!(id)
    render(conn, "show.json", case_file: case_file)
  end

  def update(conn, %{"id" => id, "case_file" => case_file_params}) do
    case_file = Trademarks.get_case_file!(id)

    with {:ok, %CaseFile{} = case_file} <-
           Trademarks.update_case_file(case_file, case_file_params) do
      render(conn, "show.json", case_file: case_file)
    end
  end

  def delete(conn, %{"id" => id}) do
    case_file = Trademarks.get_case_file!(id)

    with {:ok, %CaseFile{}} <- Trademarks.delete_case_file(case_file) do
      send_resp(conn, :no_content, "")
    end
  end
end
