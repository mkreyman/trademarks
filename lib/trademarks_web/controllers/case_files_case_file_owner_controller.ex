defmodule TrademarksWeb.CaseFilesCaseFileOwnerController do
  use TrademarksWeb, :controller

  alias Trademarks.CaseFilesCaseFileOwner

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, _params) do
    case_files_case_file_owners = Trademarks.list_case_files_case_file_owners()
    render(conn, "index.json", case_files_case_file_owners: case_files_case_file_owners)
  end

  def create(conn, %{"case_files_case_file_owner" => case_files_case_file_owner_params}) do
    with {:ok, %CaseFilesCaseFileOwner{} = case_files_case_file_owner} <-
           Trademarks.create_case_files_case_file_owner(case_files_case_file_owner_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        case_files_case_file_owner_path(conn, :show, case_files_case_file_owner)
      )
      |> render("show.json", case_files_case_file_owner: case_files_case_file_owner)
    end
  end

  def show(conn, %{"id" => id}) do
    case_files_case_file_owner = Trademarks.get_case_files_case_file_owner!(id)
    render(conn, "show.json", case_files_case_file_owner: case_files_case_file_owner)
  end

  def update(conn, %{
        "id" => id,
        "case_files_case_file_owner" => case_files_case_file_owner_params
      }) do
    case_files_case_file_owner = Trademarks.get_case_files_case_file_owner!(id)

    with {:ok, %CaseFilesCaseFileOwner{} = case_files_case_file_owner} <-
           Trademarks.update_case_files_case_file_owner(
             case_files_case_file_owner,
             case_files_case_file_owner_params
           ) do
      render(conn, "show.json", case_files_case_file_owner: case_files_case_file_owner)
    end
  end

  def delete(conn, %{"id" => id}) do
    case_files_case_file_owner = Trademarks.get_case_files_case_file_owner!(id)

    with {:ok, %CaseFilesCaseFileOwner{}} <-
           Trademarks.delete_case_files_case_file_owner(case_files_case_file_owner) do
      send_resp(conn, :no_content, "")
    end
  end
end
