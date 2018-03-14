defmodule TrademarksWeb.CaseFileOwnerController do
  use TrademarksWeb, :controller

  alias Trademarks.CaseFileOwner

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, _params) do
    case_file_owners = Trademarks.list_case_file_owners()
    render(conn, "index.json", case_file_owners: case_file_owners)
  end

  def create(conn, %{"case_file_owner" => case_file_owner_params}) do
    with {:ok, %CaseFileOwner{} = case_file_owner} <-
           Trademarks.create_case_file_owner(case_file_owner_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", case_file_owner_path(conn, :show, case_file_owner))
      |> render("show.json", case_file_owner: case_file_owner)
    end
  end

  def show(conn, %{"id" => id}) do
    case_file_owner = Trademarks.get_case_file_owner!(id)
    render(conn, "show.json", case_file_owner: case_file_owner)
  end

  def update(conn, %{"id" => id, "case_file_owner" => case_file_owner_params}) do
    case_file_owner = Trademarks.get_case_file_owner!(id)

    with {:ok, %CaseFileOwner{} = case_file_owner} <-
           Trademarks.update_case_file_owner(case_file_owner, case_file_owner_params) do
      render(conn, "show.json", case_file_owner: case_file_owner)
    end
  end

  def delete(conn, %{"id" => id}) do
    case_file_owner = Trademarks.get_case_file_owner!(id)

    with {:ok, %CaseFileOwner{}} <- Trademarks.delete_case_file_owner(case_file_owner) do
      send_resp(conn, :no_content, "")
    end
  end
end
