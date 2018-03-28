defmodule TrademarksWeb.V1.TrademarkController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{Trademark, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, %{"name" => name}) do
    page =
      Trademark
      |> where([t], ilike(t.name, ^"%#{name}%"))
      |> Repo.paginate()

    conn
    |> render("index.json-api", data: page)
  end

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
end
