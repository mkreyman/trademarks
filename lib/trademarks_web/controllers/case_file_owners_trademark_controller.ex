defmodule TrademarksWeb.CaseFileOwnersTrademarkController do
  use TrademarksWeb, :controller

  alias Trademarks.CaseFileOwnersTrademark

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, _params) do
    case_file_owners_trademarks = Trademarks.list_case_file_owners_trademarks()
    render(conn, "index.json", case_file_owners_trademarks: case_file_owners_trademarks)
  end

  def create(conn, %{"case_file_owners_trademark" => case_file_owners_trademark_params}) do
    with {:ok, %CaseFileOwnersTrademark{} = case_file_owners_trademark} <-
           Trademarks.create_case_file_owners_trademark(case_file_owners_trademark_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        case_file_owners_trademark_path(conn, :show, case_file_owners_trademark)
      )
      |> render("show.json", case_file_owners_trademark: case_file_owners_trademark)
    end
  end

  def show(conn, %{"id" => id}) do
    case_file_owners_trademark = Trademarks.get_case_file_owners_trademark!(id)
    render(conn, "show.json", case_file_owners_trademark: case_file_owners_trademark)
  end

  def update(conn, %{
        "id" => id,
        "case_file_owners_trademark" => case_file_owners_trademark_params
      }) do
    case_file_owners_trademark = Trademarks.get_case_file_owners_trademark!(id)

    with {:ok, %CaseFileOwnersTrademark{} = case_file_owners_trademark} <-
           Trademarks.update_case_file_owners_trademark(
             case_file_owners_trademark,
             case_file_owners_trademark_params
           ) do
      render(conn, "show.json", case_file_owners_trademark: case_file_owners_trademark)
    end
  end

  def delete(conn, %{"id" => id}) do
    case_file_owners_trademark = Trademarks.get_case_file_owners_trademark!(id)

    with {:ok, %CaseFileOwnersTrademark{}} <-
           Trademarks.delete_case_file_owners_trademark(case_file_owners_trademark) do
      send_resp(conn, :no_content, "")
    end
  end
end
