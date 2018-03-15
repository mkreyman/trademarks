defmodule TrademarksWeb.TrademarkController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{Trademark, Repo, Search}

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, params) do
    page =
      Trademark
      |> order_by(desc: :updated_at)
      |> Repo.paginate(params)

    conn
    |> Scrivener.Headers.paginate(page)
    |> render("index.json", trademarks: page.entries)
  end

  def show(conn, %{"id" => id}) do
    trademark = Repo.get!(Trademark, id)
    render(conn, "show.json", trademark: trademark)
  end

  def search(conn, params) do
    page = Search.by_trademark(params)

    conn
    |> Scrivener.Headers.paginate(page)
    |> render("search.json", results: page.entries)
  end

  # def index(conn, _params) do
  #   trademarks = Trademarks.list_trademarks()
  #   render(conn, "index.json", trademarks: trademarks)
  # end

  # def create(conn, %{"trademark" => trademark_params}) do
  #   with {:ok, %Trademark{} = trademark} <- Trademarks.create_trademark(trademark_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", trademark_path(conn, :show, trademark))
  #     |> render("show.json", trademark: trademark)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   trademark = Trademarks.get_trademark!(id)
  #   render(conn, "show.json", trademark: trademark)
  # end

  # def update(conn, %{"id" => id, "trademark" => trademark_params}) do
  #   trademark = Trademarks.get_trademark!(id)

  #   with {:ok, %Trademark{} = trademark} <-
  #          Trademarks.update_trademark(trademark, trademark_params) do
  #     render(conn, "show.json", trademark: trademark)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   trademark = Trademarks.get_trademark!(id)

  #   with {:ok, %Trademark{}} <- Trademarks.delete_trademark(trademark) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
