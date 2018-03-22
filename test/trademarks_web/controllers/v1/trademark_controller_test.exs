defmodule TrademarksWeb.V1.TrademarkControllerTest do
  use TrademarksWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all trademarks", %{conn: conn} do
      conn = get(conn, trademark_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end
end
