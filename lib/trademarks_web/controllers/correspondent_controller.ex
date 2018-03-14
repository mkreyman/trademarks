defmodule TrademarksWeb.CorrespondentController do
  use TrademarksWeb, :controller

  alias Trademarks.Correspondent

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, _params) do
    correspondents = Trademarks.list_correspondents()
    render(conn, "index.json", correspondents: correspondents)
  end

  def create(conn, %{"correspondent" => correspondent_params}) do
    with {:ok, %Correspondent{} = correspondent} <-
           Trademarks.create_correspondent(correspondent_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", correspondent_path(conn, :show, correspondent))
      |> render("show.json", correspondent: correspondent)
    end
  end

  def show(conn, %{"id" => id}) do
    correspondent = Trademarks.get_correspondent!(id)
    render(conn, "show.json", correspondent: correspondent)
  end

  def update(conn, %{"id" => id, "correspondent" => correspondent_params}) do
    correspondent = Trademarks.get_correspondent!(id)

    with {:ok, %Correspondent{} = correspondent} <-
           Trademarks.update_correspondent(correspondent, correspondent_params) do
      render(conn, "show.json", correspondent: correspondent)
    end
  end

  def delete(conn, %{"id" => id}) do
    correspondent = Trademarks.get_correspondent!(id)

    with {:ok, %Correspondent{}} <- Trademarks.delete_correspondent(correspondent) do
      send_resp(conn, :no_content, "")
    end
  end
end
