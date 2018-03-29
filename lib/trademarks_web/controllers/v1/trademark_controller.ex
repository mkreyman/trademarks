defmodule TrademarksWeb.V1.TrademarkController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  require IEx

  plug(TrademarksWeb.Plugs.RequireUUID, Ecto.UUID.generate())
  plug(TrademarksWeb.Plugs.ValidFilters, ~w(name limit) when action in [:index])

  alias Trademarks.{Trademark, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, %{"linked" => name}) do
    page =
      from(
        t in Trademark,
        where: ilike(t.name, ^"%#{name}%"),
        join: t2 in assoc(t, :trademarks),
        preload: [trademarks: t2]
      )
      |> Repo.paginate()

    conn
    |> render("index.json-api", data: page, opts: %{include: "trademarks"})
  end

  def index(conn, _params) do
    page =
      Trademark
      |> filtered_by(conn.assigns.filters)
      |> Repo.paginate()

    conn
    |> render("index.json-api", data: page)
  end

  def show(conn, %{"id" => id}) do
    with trademark = %Trademark{} <-
           Repo.get(Trademark, id)
           |> Repo.preload([:case_files, :case_file_owners]) do
      render(
        conn,
        "show.json-api",
        data: trademark,
        opts: %{include: "case_files,case_file_owners"}
      )
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
