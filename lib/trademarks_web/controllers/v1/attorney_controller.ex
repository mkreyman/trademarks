defmodule TrademarksWeb.V1.AttorneyController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  plug(TrademarksWeb.Plugs.ValidFilters, ~w(name) when action in [:index])

  alias Trademarks.{Attorney, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, _params) do
    page =
      Attorney
      |> filtered_by(conn.assigns.filters)
      |> Repo.paginate()

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

  defp filtered_by(query, params) do
    Enum.reduce(params, query, fn {key, value}, query ->
      case String.downcase(key) do
        _ ->
          from(a in query, where: ilike(field(a, ^String.to_atom(key)), ^"%#{value}%"))
      end
    end)
  end
end
