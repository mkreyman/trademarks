defmodule TrademarksWeb.AttorneyController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{Attorney, Repo}

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
    attorney = Repo.get!(Attorney, id)
    render(conn, "show.json", attorney: attorney)
  end
end
