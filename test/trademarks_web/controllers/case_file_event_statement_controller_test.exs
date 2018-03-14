defmodule TrademarksWeb.CaseFileEventStatementControllerTest do
  use TrademarksWeb.ConnCase

  alias Trademarks.Trademarks
  alias Trademarks.CaseFileEventStatement

  @create_attrs %{
    code: "some code",
    date: ~D[2010-04-17],
    description: "some description",
    type: "some type"
  }
  @update_attrs %{
    code: "some updated code",
    date: ~D[2011-05-18],
    description: "some updated description",
    type: "some updated type"
  }
  @invalid_attrs %{code: nil, date: nil, description: nil, type: nil}

  def fixture(:case_file_event_statement) do
    {:ok, case_file_event_statement} = Trademarks.create_case_file_event_statement(@create_attrs)
    case_file_event_statement
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all case_file_event_statements", %{conn: conn} do
      conn = get(conn, case_file_event_statement_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create case_file_event_statement" do
    test "renders case_file_event_statement when data is valid", %{conn: conn} do
      conn =
        post(
          conn,
          case_file_event_statement_path(conn, :create),
          case_file_event_statement: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, case_file_event_statement_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "code" => "some code",
               "date" => ~D[2010-04-17],
               "description" => "some description",
               "type" => "some type"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(
          conn,
          case_file_event_statement_path(conn, :create),
          case_file_event_statement: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update case_file_event_statement" do
    setup [:create_case_file_event_statement]

    test "renders case_file_event_statement when data is valid", %{
      conn: conn,
      case_file_event_statement: %CaseFileEventStatement{id: id} = case_file_event_statement
    } do
      conn =
        put(
          conn,
          case_file_event_statement_path(conn, :update, case_file_event_statement),
          case_file_event_statement: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, case_file_event_statement_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "code" => "some updated code",
               "date" => ~D[2011-05-18],
               "description" => "some updated description",
               "type" => "some updated type"
             }
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      case_file_event_statement: case_file_event_statement
    } do
      conn =
        put(
          conn,
          case_file_event_statement_path(conn, :update, case_file_event_statement),
          case_file_event_statement: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete case_file_event_statement" do
    setup [:create_case_file_event_statement]

    test "deletes chosen case_file_event_statement", %{
      conn: conn,
      case_file_event_statement: case_file_event_statement
    } do
      conn =
        delete(conn, case_file_event_statement_path(conn, :delete, case_file_event_statement))

      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, case_file_event_statement_path(conn, :show, case_file_event_statement))
      end)
    end
  end

  defp create_case_file_event_statement(_) do
    case_file_event_statement = fixture(:case_file_event_statement)
    {:ok, case_file_event_statement: case_file_event_statement}
  end
end
