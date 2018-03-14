defmodule TrademarksWeb.CaseFileOwnersTrademarkControllerTest do
  use TrademarksWeb.ConnCase

  alias Trademarks.Trademarks
  alias Trademarks.CaseFileOwnersTrademark

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:case_file_owners_trademark) do
    {:ok, case_file_owners_trademark} =
      Trademarks.create_case_file_owners_trademark(@create_attrs)

    case_file_owners_trademark
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all case_file_owners_trademarks", %{conn: conn} do
      conn = get(conn, case_file_owners_trademark_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create case_file_owners_trademark" do
    test "renders case_file_owners_trademark when data is valid", %{conn: conn} do
      conn =
        post(
          conn,
          case_file_owners_trademark_path(conn, :create),
          case_file_owners_trademark: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, case_file_owners_trademark_path(conn, :show, id))
      assert json_response(conn, 200)["data"] == %{"id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(
          conn,
          case_file_owners_trademark_path(conn, :create),
          case_file_owners_trademark: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update case_file_owners_trademark" do
    setup [:create_case_file_owners_trademark]

    test "renders case_file_owners_trademark when data is valid", %{
      conn: conn,
      case_file_owners_trademark: %CaseFileOwnersTrademark{id: id} = case_file_owners_trademark
    } do
      conn =
        put(
          conn,
          case_file_owners_trademark_path(conn, :update, case_file_owners_trademark),
          case_file_owners_trademark: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, case_file_owners_trademark_path(conn, :show, id))
      assert json_response(conn, 200)["data"] == %{"id" => id}
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      case_file_owners_trademark: case_file_owners_trademark
    } do
      conn =
        put(
          conn,
          case_file_owners_trademark_path(conn, :update, case_file_owners_trademark),
          case_file_owners_trademark: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete case_file_owners_trademark" do
    setup [:create_case_file_owners_trademark]

    test "deletes chosen case_file_owners_trademark", %{
      conn: conn,
      case_file_owners_trademark: case_file_owners_trademark
    } do
      conn =
        delete(conn, case_file_owners_trademark_path(conn, :delete, case_file_owners_trademark))

      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, case_file_owners_trademark_path(conn, :show, case_file_owners_trademark))
      end)
    end
  end

  defp create_case_file_owners_trademark(_) do
    case_file_owners_trademark = fixture(:case_file_owners_trademark)
    {:ok, case_file_owners_trademark: case_file_owners_trademark}
  end
end
