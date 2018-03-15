defmodule TrademarksWeb.CaseFileOwnerController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{CaseFileOwner, Repo}

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
    case_file_owner = Repo.get!(CaseFileOwner, id)
    render(conn, "show.json", case_file_owners: case_file_owner)
  end
end
