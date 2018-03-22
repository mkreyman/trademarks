defmodule TrademarksWeb.CorrespondentController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{Correspondent, Repo}
  alias TrademarksWeb.ErrorView

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
    with correspondent = %Correspondent{} <- Repo.get(Correspondent, id) do
      render(conn, "show.json", correspondent: correspondent)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end