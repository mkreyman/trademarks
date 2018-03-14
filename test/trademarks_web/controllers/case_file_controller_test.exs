defmodule TrademarksWeb.CaseFileControllerTest do
  use TrademarksWeb.ConnCase

  alias Trademarks.Trademarks
  alias Trademarks.CaseFile

  @create_attrs %{
    abandonment_date: ~D[2010-04-17],
    filing_date: ~D[2010-04-17],
    registration_date: ~D[2010-04-17],
    registration_number: "some registration_number",
    renewal_date: ~D[2010-04-17],
    serial_number: "some serial_number",
    status_date: ~D[2010-04-17]
  }
  @update_attrs %{
    abandonment_date: ~D[2011-05-18],
    filing_date: ~D[2011-05-18],
    registration_date: ~D[2011-05-18],
    registration_number: "some updated registration_number",
    renewal_date: ~D[2011-05-18],
    serial_number: "some updated serial_number",
    status_date: ~D[2011-05-18]
  }
  @invalid_attrs %{
    abandonment_date: nil,
    filing_date: nil,
    registration_date: nil,
    registration_number: nil,
    renewal_date: nil,
    serial_number: nil,
    status_date: nil
  }

  def fixture(:case_file) do
    {:ok, case_file} = Trademarks.create_case_file(@create_attrs)
    case_file
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all case_files", %{conn: conn} do
      conn = get(conn, case_file_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create case_file" do
    test "renders case_file when data is valid", %{conn: conn} do
      conn = post(conn, case_file_path(conn, :create), case_file: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, case_file_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "abandonment_date" => ~D[2010-04-17],
               "filing_date" => ~D[2010-04-17],
               "registration_date" => ~D[2010-04-17],
               "registration_number" => "some registration_number",
               "renewal_date" => ~D[2010-04-17],
               "serial_number" => "some serial_number",
               "status_date" => ~D[2010-04-17]
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, case_file_path(conn, :create), case_file: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update case_file" do
    setup [:create_case_file]

    test "renders case_file when data is valid", %{
      conn: conn,
      case_file: %CaseFile{id: id} = case_file
    } do
      conn = put(conn, case_file_path(conn, :update, case_file), case_file: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, case_file_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "abandonment_date" => ~D[2011-05-18],
               "filing_date" => ~D[2011-05-18],
               "registration_date" => ~D[2011-05-18],
               "registration_number" => "some updated registration_number",
               "renewal_date" => ~D[2011-05-18],
               "serial_number" => "some updated serial_number",
               "status_date" => ~D[2011-05-18]
             }
    end

    test "renders errors when data is invalid", %{conn: conn, case_file: case_file} do
      conn = put(conn, case_file_path(conn, :update, case_file), case_file: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete case_file" do
    setup [:create_case_file]

    test "deletes chosen case_file", %{conn: conn, case_file: case_file} do
      conn = delete(conn, case_file_path(conn, :delete, case_file))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, case_file_path(conn, :show, case_file))
      end)
    end
  end

  defp create_case_file(_) do
    case_file = fixture(:case_file)
    {:ok, case_file: case_file}
  end
end
