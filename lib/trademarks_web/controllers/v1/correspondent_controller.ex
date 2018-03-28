defmodule TrademarksWeb.V1.CorrespondentController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  plug(
    TrademarksWeb.Plugs.ValidFilters,
    ~w(name address_1 address_2 address_3 address_4 address_5) when action in [:index]
  )

  alias Trademarks.{Correspondent, Repo}
  alias TrademarksWeb.ErrorView

  action_fallback(TrademarksWeb.FallbackController)

  def index(conn, _params) do
    page =
      Correspondent
      |> filtered_by(conn.assigns.filters)
      |> Repo.paginate()

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

  defp filtered_by(query, params) do
    Enum.reduce(params, query, fn {key, value}, query ->
      case String.downcase(key) do
        "name" ->
          from(c in query, where: ilike(c.address_1, ^"%#{value}%"))

        _ ->
          from(c in query, where: ilike(field(c, ^String.to_atom(key)), ^"%#{value}%"))
      end
    end)
  end
end
