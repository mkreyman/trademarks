defmodule TrademarksWeb.V1.AttorneyController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  plug(TrademarksWeb.Plugs.ValidFilters, ~w(name limit) when action in [:index])

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

  defp filtered_by(query, []), do: query

  defp filtered_by(query, params) do
    Enum.reduce(params, query, fn {key, value}, query ->
      case String.downcase(key) do
        "limit" ->
          try do
            query
            |> limit(^String.to_integer(value))
            |> filtered_by(Keyword.drop(params, ["limit"]))
          rescue
            _ ->
              query
              |> filtered_by(Keyword.drop(params, ["limit"]))
          end

        _ ->
          from(t in query, where: ilike(field(t, ^String.to_atom(key)), ^"%#{value}%"))
          |> filtered_by(Keyword.drop(params, [key]))
      end
    end)
  end
end
