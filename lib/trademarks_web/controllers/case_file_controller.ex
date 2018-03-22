defmodule TrademarksWeb.CaseFileController do
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
    |> Scrivener.Headers.paginate(page)
    |> render("index.json", case_files: page.entries)
  end

  def show(conn, %{"id" => id}) do
    with case_file = %CaseFile{} <- Repo.get(CaseFile, id) do
      render(conn, "show.json", case_file: case_file)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end