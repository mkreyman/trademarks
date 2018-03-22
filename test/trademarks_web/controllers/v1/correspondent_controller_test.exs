defmodule TrademarksWeb.V1.CorrespondentControllerTest do
  use TrademarksWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all correspondents", %{conn: conn} do
      conn = get(conn, correspondent_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end
end
