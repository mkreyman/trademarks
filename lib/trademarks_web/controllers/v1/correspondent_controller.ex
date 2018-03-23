defmodule TrademarksWeb.V1.CorrespondentController do
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
    |> render("index.json-api", data: page)
  end

  def show(conn, %{"id" => id}) do
    with correspondent = %Correspondent{} <- Repo.get(Correspondent, id) do
      render(conn, "show.json-api", data: correspondent)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json-api", error: "Not found")
    end
  end
end
