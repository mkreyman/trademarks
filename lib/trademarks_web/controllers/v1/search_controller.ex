defmodule TrademarksWeb.V1.SearchController do
  use TrademarksWeb, :controller
  import Ecto.Query, warn: false

  alias Trademarks.{Repo, Search}

  action_fallback(TrademarksWeb.FallbackController)

  def search(conn, params) do
    results =
      case params do
        %{"attorney" => name} -> Search.by_attorney(name)
        %{"owner" => party_name} -> Search.by_owner(party_name)
        %{"correspondent" => address_1} -> Search.by_correspondent(address_1)
        %{"trademark" => name} -> Search.by_trademark(name)
        %{"linked" => name} -> Search.linked_trademarks(name)
      end
      |> Repo.paginate(params)

    conn
    |> render("search.json-api", %{
      data: results,
      query_params: conn.query_params,
      request_path: conn.request_path,
      base_url: Application.get_env(:ja_serializer, :page_base_url, conn.request_path)
    })
  end
end
