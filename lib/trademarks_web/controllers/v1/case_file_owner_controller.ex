defmodule TrademarksWeb.V1.CaseFileOwnerController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{CaseFileOwner, Repo}
  alias TrademarksWeb.ErrorView

  def index(conn, params) do
    page =
      case params do
        %{"name" => name} ->
          CaseFileOwner
          |> where([o], ilike(o.party_name, ^"%#{name}%"))
          |> Repo.paginate()

        _ ->
          CaseFileOwner
          |> Repo.paginate()
      end

    conn
    |> render("index.json-api", data: page)
  end

  def show(conn, %{"id" => id}) do
    with case_file_owner = %CaseFileOwner{} <-
           Repo.get(CaseFileOwner, id)
           |> Repo.preload([:case_files]) do
      render(conn, "show.json-api", data: case_file_owner, opts: %{include: "case_files"})
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json-api", error: "Not found")
    end
  end
end
