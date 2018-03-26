defmodule TrademarksWeb.V1.CaseFileOwnerControllerTest do
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

  describe "index" do
    test "lists all case_file_owners", %{conn: conn} do
      conn = get(conn, api_v1_case_file_owner_path(conn, :index))
      assert conn.status == 200
      assert [@content_type_header] = get_resp_header(conn, "content-type")
      # assert json_response(conn, 200)["data"] == []
    end
  end
end
