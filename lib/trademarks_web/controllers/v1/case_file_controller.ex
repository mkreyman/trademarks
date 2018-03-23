defmodule TrademarksWeb.V1.CaseFileController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{CaseFile, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, params) do
    page =
      CaseFile
      |> order_by(desc: :updated_at)
      |> Repo.paginate(params)

    conn
    |> render("index.json-api", data: page)
  end

  def show(conn, %{"id" => id}) do
    with case_file = %CaseFile{} <- Repo.get(CaseFile, id) do
      render(conn, "show.json-api", data: case_file)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json-api", error: "Not found")
    end
  end
end
