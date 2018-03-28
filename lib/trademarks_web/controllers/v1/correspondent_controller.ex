defmodule TrademarksWeb.V1.CorrespondentController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{Correspondent, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, params) do
    page =
      case params do
        %{"name" => name} ->
          Correspondent
          |> where([c], ilike(c.address_1, ^"%#{name}%"))
          |> Repo.paginate()

        _ ->
          Correspondent
          |> Repo.paginate()
      end

    conn
    |> render("index.json-api", data: page)
  end

  def show(conn, %{"id" => id}) do
    with correspondent = %Correspondent{} <-
           Repo.get(Correspondent, id)
           |> Repo.preload([:case_files]) do
      render(conn, "show.json-api", data: correspondent, opts: %{include: "case_files"})
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json-api", error: "Not found")
    end
  end
end
