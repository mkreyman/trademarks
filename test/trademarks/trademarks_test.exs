defmodule Trademarks.TrademarksTest do
  use Trademarks.DataCase

  describe "trademarks" do
    # alias Trademarks.Trademark

    @valid_attrs %{name: "some name"}

    def trademark_fixture(attrs \\ %{}) do
      {:ok, trademark} =
        attrs
        |> Enum.into(@valid_attrs)

      # |> Trademarks.create_trademark()

      trademark
    end

    @tag :pending
    test "list_trademarks/0 returns all trademarks" do
      trademark = trademark_fixture()
      assert Trademarks.list_trademarks() == [trademark]
    end

    @tag :pending
    test "get_trademark!/1 returns the trademark with given id" do
      trademark = trademark_fixture()
      assert Trademarks.get_trademark!(trademark.id) == trademark
    end
  end

  describe "attorneys" do
    # alias Trademarks.Attorney

    @valid_attrs %{name: "some name"}

    def attorney_fixture(attrs \\ %{}) do
      {:ok, attorney} =
        attrs
        |> Enum.into(@valid_attrs)

      # |> Trademarks.create_attorney()

      attorney
    end

    @tag :pending
    test "list_attorneys/0 returns all attorneys" do
      attorney = attorney_fixture()
      assert Trademarks.list_attorneys() == [attorney]
    end

    @tag :pending
    test "get_attorney!/1 returns the attorney with given id" do
      attorney = attorney_fixture()
      assert Trademarks.get_attorney!(attorney.id) == attorney
    end
  end

  describe "correspondents" do
    # alias Trademarks.Correspondent

    @valid_attrs %{
      address_1: "some address_1",
      address_2: "some address_2",
      address_3: "some address_3",
      address_4: "some address_4",
      address_5: "some address_5"
    }

    def correspondent_fixture(attrs \\ %{}) do
      {:ok, correspondent} =
        attrs
        |> Enum.into(@valid_attrs)

      # |> Trademarks.create_correspondent()

      correspondent
    end

    @tag :pending
    test "list_correspondents/0 returns all correspondents" do
      correspondent = correspondent_fixture()
      assert Trademarks.list_correspondents() == [correspondent]
    end

    @tag :pending
    test "get_correspondent!/1 returns the correspondent with given id" do
      correspondent = correspondent_fixture()
      assert Trademarks.get_correspondent!(correspondent.id) == correspondent
    end
  end

  describe "case_files" do
    # alias Trademarks.CaseFile

    @valid_attrs %{
      abandonment_date: ~D[2010-04-17],
      filing_date: ~D[2010-04-17],
      registration_date: ~D[2010-04-17],
      registration_number: "some registration_number",
      renewal_date: ~D[2010-04-17],
      serial_number: "some serial_number",
      status_date: ~D[2010-04-17]
    }

    def case_file_fixture(attrs \\ %{}) do
      {:ok, case_file} =
        attrs
        |> Enum.into(@valid_attrs)

      # |> Trademarks.create_case_file()

      case_file
    end

    @tag :pending
    test "get_case_file!/1 returns the case_file with given id" do
      case_file = case_file_fixture()
      assert Trademarks.get_case_file!(case_file.id) == case_file
    end
  end

  describe "case_file_owners" do
    # alias Trademarks.CaseFileOwner

    @valid_attrs %{
      address_1: "some address_1",
      address_2: "some address_2",
      city: "some city",
      country: "some country",
      dba: "some dba",
      nationality_country: "some nationality_country",
      nationality_state: "some nationality_state",
      name: "some name",
      postcode: "some postcode",
      state: "some state"
    }

    def case_file_owner_fixture(attrs \\ %{}) do
      {:ok, case_file_owner} =
        attrs
        |> Enum.into(@valid_attrs)

      # |> Trademarks.create_case_file_owner()

      case_file_owner
    end

    @tag :pending
    test "list_case_file_owners/0 returns all case_file_owners" do
      case_file_owner = case_file_owner_fixture()
      assert Trademarks.list_case_file_owners() == [case_file_owner]
    end

    @tag :pending
    test "get_case_file_owner!/1 returns the case_file_owner with given id" do
      case_file_owner = case_file_owner_fixture()
      assert Trademarks.get_case_file_owner!(case_file_owner.id) == case_file_owner
    end
  end
end
