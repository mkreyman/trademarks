defmodule TrademarksWeb.V1.TrademarkController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{Trademark, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, params) do
    page =
      Trademark
      |> Repo.paginate(params)

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

  # @TODO: figure out how to do this...
  #
  # def search(conn, name) do
  #   query =
  #     from(
  #     t in Trademark,
  #     where: ilike(t.name, ^"%#{name}%"),
  #     left_join: f in assoc(t, :case_files),
  #     left_join: o in assoc(t, :case_file_owners),
  #     preload: [case_files: f, case_file_owners: o]
  #   )

  #   results =
  #     query
  #     |> Repo.all()
  #     |> Repo.paginate()

  #   data =
  #     %{data: results,
  #       query_params: conn.query_params,
  #       request_path: conn.request_path,
  #       base_url: Application.get_env(:ja_serializer, :page_base_url, conn.request_path)}

  #   conn
  #   |> render("search.json-api", data)
  # end
end
