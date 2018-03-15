defmodule TrademarksWeb.CaseFileController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{CaseFile, Repo}

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
    case_file = Repo.get!(CaseFile, id)
    render(conn, "show.json", case_file: case_file)
  end
end
