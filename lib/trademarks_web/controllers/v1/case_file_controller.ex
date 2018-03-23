defmodule TrademarksWeb.V1.CaseFileController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{CaseFile, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def show(conn, %{"id" => id}) do
    with case_file = %CaseFile{} <-
           Repo.get(CaseFile, id)
           |> Repo.preload([
             :trademark,
             :case_file_owners,
             :correspondent,
             :case_file_statements,
             :case_file_event_statements
           ]) do
      render(conn, "show.json-api", data: case_file)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json-api", error: "Not found")
    end
  end
end
