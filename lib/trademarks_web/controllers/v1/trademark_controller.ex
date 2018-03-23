defmodule TrademarksWeb.V1.TrademarkController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{Trademark, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, params) do
    page =
      Trademark
      |> order_by(desc: :updated_at)
      |> Repo.paginate(params)

    conn
    |> render("index.json-api", data: page)
  end

  def show(conn, %{"id" => id}) do
    with trademark = %Trademark{} <- Repo.get(Trademark, id) do
      render(conn, "show.json-api", data: trademark)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json-api", error: "Not found")
    end
  end
end
