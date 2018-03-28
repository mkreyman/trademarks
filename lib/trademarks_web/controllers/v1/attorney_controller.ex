defmodule TrademarksWeb.V1.AttorneyController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{Attorney, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, params) do
    page =
      case params do
        %{"name" => name} ->
          Attorney
          |> where([a], ilike(a.name, ^"%#{name}%"))
          |> Repo.paginate()

        _ ->
          Attorney
          |> Repo.paginate()
      end

    conn
    |> render("index.json-api", data: page)
  end

  def show(conn, %{"id" => id}) do
    with attorney = %Attorney{} <-
           Repo.get(Attorney, id)
           |> Repo.preload([:case_files]) do
      render(conn, "show.json-api", data: attorney, opts: %{include: "case_files"})
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json-api", error: "Not found")
    end
  end
end
