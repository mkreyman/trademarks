defmodule TrademarksWeb.V1.CaseFileControllerTest do
  use TrademarksWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all case_files", %{conn: conn} do
      conn = get(conn, case_file_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end
end
