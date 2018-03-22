defmodule TrademarksWeb.V1.AttorneyControllerTest do
  use TrademarksWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all attorneys", %{conn: conn} do
      conn = get(conn, attorney_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end
end
