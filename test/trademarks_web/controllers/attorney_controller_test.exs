defmodule TrademarksWeb.AttorneyControllerTest do
  use TrademarksWeb.ConnCase

  alias Trademarks.Trademarks
  alias Trademarks.Attorney

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:attorney) do
    {:ok, attorney} = Trademarks.create_attorney(@create_attrs)
    attorney
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all attorneys", %{conn: conn} do
      conn = get(conn, attorney_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create attorney" do
    test "renders attorney when data is valid", %{conn: conn} do
      conn = post(conn, attorney_path(conn, :create), attorney: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, attorney_path(conn, :show, id))
      assert json_response(conn, 200)["data"] == %{"id" => id, "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, attorney_path(conn, :create), attorney: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update attorney" do
    setup [:create_attorney]

    test "renders attorney when data is valid", %{
      conn: conn,
      attorney: %Attorney{id: id} = attorney
    } do
      conn = put(conn, attorney_path(conn, :update, attorney), attorney: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, attorney_path(conn, :show, id))
      assert json_response(conn, 200)["data"] == %{"id" => id, "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, attorney: attorney} do
      conn = put(conn, attorney_path(conn, :update, attorney), attorney: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete attorney" do
    setup [:create_attorney]

    test "deletes chosen attorney", %{conn: conn, attorney: attorney} do
      conn = delete(conn, attorney_path(conn, :delete, attorney))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, attorney_path(conn, :show, attorney))
      end)
    end
  end

  defp create_attorney(_) do
    attorney = fixture(:attorney)
    {:ok, attorney: attorney}
  end
end
