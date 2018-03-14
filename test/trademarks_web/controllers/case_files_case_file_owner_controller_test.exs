defmodule TrademarksWeb.CaseFilesCaseFileOwnerControllerTest do
  use TrademarksWeb.ConnCase

  alias Trademarks.Trademarks
  alias Trademarks.CaseFilesCaseFileOwner

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:case_files_case_file_owner) do
    {:ok, case_files_case_file_owner} =
      Trademarks.create_case_files_case_file_owner(@create_attrs)

    case_files_case_file_owner
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all case_files_case_file_owners", %{conn: conn} do
      conn = get(conn, case_files_case_file_owner_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create case_files_case_file_owner" do
    test "renders case_files_case_file_owner when data is valid", %{conn: conn} do
      conn =
        post(
          conn,
          case_files_case_file_owner_path(conn, :create),
          case_files_case_file_owner: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, case_files_case_file_owner_path(conn, :show, id))
      assert json_response(conn, 200)["data"] == %{"id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(
          conn,
          case_files_case_file_owner_path(conn, :create),
          case_files_case_file_owner: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update case_files_case_file_owner" do
    setup [:create_case_files_case_file_owner]

    test "renders case_files_case_file_owner when data is valid", %{
      conn: conn,
      case_files_case_file_owner: %CaseFilesCaseFileOwner{id: id} = case_files_case_file_owner
    } do
      conn =
        put(
          conn,
          case_files_case_file_owner_path(conn, :update, case_files_case_file_owner),
          case_files_case_file_owner: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, case_files_case_file_owner_path(conn, :show, id))
      assert json_response(conn, 200)["data"] == %{"id" => id}
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      case_files_case_file_owner: case_files_case_file_owner
    } do
      conn =
        put(
          conn,
          case_files_case_file_owner_path(conn, :update, case_files_case_file_owner),
          case_files_case_file_owner: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete case_files_case_file_owner" do
    setup [:create_case_files_case_file_owner]

    test "deletes chosen case_files_case_file_owner", %{
      conn: conn,
      case_files_case_file_owner: case_files_case_file_owner
    } do
      conn =
        delete(conn, case_files_case_file_owner_path(conn, :delete, case_files_case_file_owner))

      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, case_files_case_file_owner_path(conn, :show, case_files_case_file_owner))
      end)
    end
  end

  defp create_case_files_case_file_owner(_) do
    case_files_case_file_owner = fixture(:case_files_case_file_owner)
    {:ok, case_files_case_file_owner: case_files_case_file_owner}
  end
end
