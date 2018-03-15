defmodule TrademarksWeb.CorrespondentController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{Correspondent, Repo}

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, params) do
    page =
      Correspondent
      |> order_by(desc: :updated_at)
      |> Repo.paginate(params)

    conn
    |> Scrivener.Headers.paginate(page)
    |> render("index.json", correspondents: page.entries)
  end

  def show(conn, %{"id" => id}) do
    correspondent = Repo.get!(Correspondent, id)
    render(conn, "show.json", correspondent: correspondent)
  end
end
