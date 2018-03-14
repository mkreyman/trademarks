defmodule TrademarksWeb.CorrespondentControllerTest do
  use TrademarksWeb.ConnCase

  alias Trademarks.Trademarks
  alias Trademarks.Correspondent

  @create_attrs %{
    address_1: "some address_1",
    address_2: "some address_2",
    address_3: "some address_3",
    address_4: "some address_4",
    address_5: "some address_5"
  }
  @update_attrs %{
    address_1: "some updated address_1",
    address_2: "some updated address_2",
    address_3: "some updated address_3",
    address_4: "some updated address_4",
    address_5: "some updated address_5"
  }
  @invalid_attrs %{address_1: nil, address_2: nil, address_3: nil, address_4: nil, address_5: nil}

  def fixture(:correspondent) do
    {:ok, correspondent} = Trademarks.create_correspondent(@create_attrs)
    correspondent
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all correspondents", %{conn: conn} do
      conn = get(conn, correspondent_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create correspondent" do
    test "renders correspondent when data is valid", %{conn: conn} do
      conn = post(conn, correspondent_path(conn, :create), correspondent: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, correspondent_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "address_1" => "some address_1",
               "address_2" => "some address_2",
               "address_3" => "some address_3",
               "address_4" => "some address_4",
               "address_5" => "some address_5"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, correspondent_path(conn, :create), correspondent: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update correspondent" do
    setup [:create_correspondent]

    test "renders correspondent when data is valid", %{
      conn: conn,
      correspondent: %Correspondent{id: id} = correspondent
    } do
      conn =
        put(conn, correspondent_path(conn, :update, correspondent), correspondent: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, correspondent_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "address_1" => "some updated address_1",
               "address_2" => "some updated address_2",
               "address_3" => "some updated address_3",
               "address_4" => "some updated address_4",
               "address_5" => "some updated address_5"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, correspondent: correspondent} do
      conn =
        put(conn, correspondent_path(conn, :update, correspondent), correspondent: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete correspondent" do
    setup [:create_correspondent]

    test "deletes chosen correspondent", %{conn: conn, correspondent: correspondent} do
      conn = delete(conn, correspondent_path(conn, :delete, correspondent))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, correspondent_path(conn, :show, correspondent))
      end)
    end
  end

  defp create_correspondent(_) do
    correspondent = fixture(:correspondent)
    {:ok, correspondent: correspondent}
  end
end
