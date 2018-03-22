defmodule TrademarksWeb.V1.CaseFileOwnerControllerTest do
  use TrademarksWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all case_file_owners", %{conn: conn} do
      conn = get(conn, case_file_owner_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end
end
