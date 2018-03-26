defmodule TrademarksWeb.V1.TrademarkControllerTest do
  use TrademarksWeb.ConnCase

  @accept_header "application/vnd.api+json"
  @content_type_header "application/vnd.api+json; charset=utf-8"

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", @accept_header)
      |> put_req_header("content-type", @content_type_header)

    {:ok, conn: conn}
  end

  @tag :pending
  describe "index" do
    test "lists all trademarks", %{conn: conn} do
      conn = get(conn, api_v1_trademark_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end
end
