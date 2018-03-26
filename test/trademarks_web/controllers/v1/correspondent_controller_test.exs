defmodule TrademarksWeb.V1.CorrespondentControllerTest do
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
    test "lists all correspondents", %{conn: conn} do
      conn = get(conn, api_v1_correspondent_path(conn, :index))
      assert conn.status == 200
      assert [@content_type_header] = get_resp_header(conn, "content-type")
      # assert json_response(conn, 200)["data"] == []
    end
  end
end
