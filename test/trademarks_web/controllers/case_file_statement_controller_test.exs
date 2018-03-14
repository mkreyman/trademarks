defmodule TrademarksWeb.CaseFileStatementControllerTest do
  use TrademarksWeb.ConnCase

  alias Trademarks.Trademarks
  alias Trademarks.CaseFileStatement

  @create_attrs %{description: "some description", type_code: "some type_code"}
  @update_attrs %{description: "some updated description", type_code: "some updated type_code"}
  @invalid_attrs %{description: nil, type_code: nil}

  def fixture(:case_file_statement) do
    {:ok, case_file_statement} = Trademarks.create_case_file_statement(@create_attrs)
    case_file_statement
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all case_file_statements", %{conn: conn} do
      conn = get(conn, case_file_statement_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create case_file_statement" do
    test "renders case_file_statement when data is valid", %{conn: conn} do
      conn =
        post(conn, case_file_statement_path(conn, :create), case_file_statement: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, case_file_statement_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "description" => "some description",
               "type_code" => "some type_code"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, case_file_statement_path(conn, :create), case_file_statement: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update case_file_statement" do
    setup [:create_case_file_statement]

    test "renders case_file_statement when data is valid", %{
      conn: conn,
      case_file_statement: %CaseFileStatement{id: id} = case_file_statement
    } do
      conn =
        put(
          conn,
          case_file_statement_path(conn, :update, case_file_statement),
          case_file_statement: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, case_file_statement_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "description" => "some updated description",
               "type_code" => "some updated type_code"
             }
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      case_file_statement: case_file_statement
    } do
      conn =
        put(
          conn,
          case_file_statement_path(conn, :update, case_file_statement),
          case_file_statement: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete case_file_statement" do
    setup [:create_case_file_statement]

    test "deletes chosen case_file_statement", %{
      conn: conn,
      case_file_statement: case_file_statement
    } do
      conn = delete(conn, case_file_statement_path(conn, :delete, case_file_statement))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, case_file_statement_path(conn, :show, case_file_statement))
      end)
    end
  end

  defp create_case_file_statement(_) do
    case_file_statement = fixture(:case_file_statement)
    {:ok, case_file_statement: case_file_statement}
  end
end
