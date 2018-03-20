defmodule TrademarksWeb.CaseFileOwnerController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{CaseFileOwner, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, params) do
    page =
      CaseFileOwner
      |> order_by(desc: :updated_at)
      |> Repo.paginate(params)

    conn
    |> Scrivener.Headers.paginate(page)
    |> render("index.json", case_file_owners: page.entries)
  end

  def show(conn, %{"id" => id}) do
    with case_file_owner = %CaseFileOwner{} <- Repo.get(CaseFileOwner, id) do
      render(conn, "show.json", case_file_owner: case_file_owner)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end
