defmodule TrademarksWeb.V1.AttorneyController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{Attorney, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, params) do
    page =
      Attorney
      |> order_by(desc: :updated_at)
      |> Repo.paginate(params)

    conn
    |> Scrivener.Headers.paginate(page)
    |> render("index.json", attorneys: page.entries)
  end

  def show(conn, %{"id" => id}) do
    with attorney = %Attorney{} <- Repo.get(Attorney, id) do
      render(conn, "show.json", attorney: attorney)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end
