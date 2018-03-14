defmodule TrademarksWeb.CaseFileOwnerControllerTest do
  use TrademarksWeb.ConnCase

  alias Trademarks.Trademarks
  alias Trademarks.CaseFileOwner

  @create_attrs %{
    address_1: "some address_1",
    address_2: "some address_2",
    city: "some city",
    country: "some country",
    dba: "some dba",
    nationality_country: "some nationality_country",
    nationality_state: "some nationality_state",
    party_name: "some party_name",
    postcode: "some postcode",
    state: "some state"
  }
  @update_attrs %{
    address_1: "some updated address_1",
    address_2: "some updated address_2",
    city: "some updated city",
    country: "some updated country",
    dba: "some updated dba",
    nationality_country: "some updated nationality_country",
    nationality_state: "some updated nationality_state",
    party_name: "some updated party_name",
    postcode: "some updated postcode",
    state: "some updated state"
  }
  @invalid_attrs %{
    address_1: nil,
    address_2: nil,
    city: nil,
    country: nil,
    dba: nil,
    nationality_country: nil,
    nationality_state: nil,
    party_name: nil,
    postcode: nil,
    state: nil
  }

  def fixture(:case_file_owner) do
    {:ok, case_file_owner} = Trademarks.create_case_file_owner(@create_attrs)
    case_file_owner
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all case_file_owners", %{conn: conn} do
      conn = get(conn, case_file_owner_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create case_file_owner" do
    test "renders case_file_owner when data is valid", %{conn: conn} do
      conn = post(conn, case_file_owner_path(conn, :create), case_file_owner: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, case_file_owner_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "address_1" => "some address_1",
               "address_2" => "some address_2",
               "city" => "some city",
               "country" => "some country",
               "dba" => "some dba",
               "nationality_country" => "some nationality_country",
               "nationality_state" => "some nationality_state",
               "party_name" => "some party_name",
               "postcode" => "some postcode",
               "state" => "some state"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, case_file_owner_path(conn, :create), case_file_owner: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update case_file_owner" do
    setup [:create_case_file_owner]

    test "renders case_file_owner when data is valid", %{
      conn: conn,
      case_file_owner: %CaseFileOwner{id: id} = case_file_owner
    } do
      conn =
        put(
          conn,
          case_file_owner_path(conn, :update, case_file_owner),
          case_file_owner: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, case_file_owner_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "address_1" => "some updated address_1",
               "address_2" => "some updated address_2",
               "city" => "some updated city",
               "country" => "some updated country",
               "dba" => "some updated dba",
               "nationality_country" => "some updated nationality_country",
               "nationality_state" => "some updated nationality_state",
               "party_name" => "some updated party_name",
               "postcode" => "some updated postcode",
               "state" => "some updated state"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, case_file_owner: case_file_owner} do
      conn =
        put(
          conn,
          case_file_owner_path(conn, :update, case_file_owner),
          case_file_owner: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete case_file_owner" do
    setup [:create_case_file_owner]

    test "deletes chosen case_file_owner", %{conn: conn, case_file_owner: case_file_owner} do
      conn = delete(conn, case_file_owner_path(conn, :delete, case_file_owner))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, case_file_owner_path(conn, :show, case_file_owner))
      end)
    end
  end

  defp create_case_file_owner(_) do
    case_file_owner = fixture(:case_file_owner)
    {:ok, case_file_owner: case_file_owner}
  end
end
