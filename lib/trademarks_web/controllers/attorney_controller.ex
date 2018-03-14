defmodule TrademarksWeb.AttorneyController do
  use TrademarksWeb, :controller

  alias Trademarks.Attorney

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, _params) do
    attorneys = Trademarks.list_attorneys()
    render(conn, "index.json", attorneys: attorneys)
  end

  def create(conn, %{"attorney" => attorney_params}) do
    with {:ok, %Attorney{} = attorney} <- Trademarks.create_attorney(attorney_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", attorney_path(conn, :show, attorney))
      |> render("show.json", attorney: attorney)
    end
  end

  def show(conn, %{"id" => id}) do
    attorney = Trademarks.get_attorney!(id)
    render(conn, "show.json", attorney: attorney)
  end

  def update(conn, %{"id" => id, "attorney" => attorney_params}) do
    attorney = Trademarks.get_attorney!(id)

    with {:ok, %Attorney{} = attorney} <- Trademarks.update_attorney(attorney, attorney_params) do
      render(conn, "show.json", attorney: attorney)
    end
  end

  def delete(conn, %{"id" => id}) do
    attorney = Trademarks.get_attorney!(id)

    with {:ok, %Attorney{}} <- Trademarks.delete_attorney(attorney) do
      send_resp(conn, :no_content, "")
    end
  end
end
