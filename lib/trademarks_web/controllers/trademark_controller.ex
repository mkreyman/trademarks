defmodule TrademarksWeb.TrademarkController do
  use TrademarksWeb, :controller

  alias Trademarks.Trademark

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, _params) do
    trademarks = Trademarks.list_trademarks()
    render(conn, "index.json", trademarks: trademarks)
  end

  def create(conn, %{"trademark" => trademark_params}) do
    with {:ok, %Trademark{} = trademark} <- Trademarks.create_trademark(trademark_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", trademark_path(conn, :show, trademark))
      |> render("show.json", trademark: trademark)
    end
  end

  def show(conn, %{"id" => id}) do
    trademark = Trademarks.get_trademark!(id)
    render(conn, "show.json", trademark: trademark)
  end

  def update(conn, %{"id" => id, "trademark" => trademark_params}) do
    trademark = Trademarks.get_trademark!(id)

    with {:ok, %Trademark{} = trademark} <-
           Trademarks.update_trademark(trademark, trademark_params) do
      render(conn, "show.json", trademark: trademark)
    end
  end

  def delete(conn, %{"id" => id}) do
    trademark = Trademarks.get_trademark!(id)

    with {:ok, %Trademark{}} <- Trademarks.delete_trademark(trademark) do
      send_resp(conn, :no_content, "")
    end
  end
end
