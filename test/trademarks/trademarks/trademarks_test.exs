defmodule Trademarks.TrademarksTest do
  use Trademarks.DataCase

  alias Trademarks.Trademarks

  describe "trademarks" do
    alias Trademarks.Trademark

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def trademark_fixture(attrs \\ %{}) do
      {:ok, trademark} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trademarks.create_trademark()

      trademark
    end

    test "list_trademarks/0 returns all trademarks" do
      trademark = trademark_fixture()
      assert Trademarks.list_trademarks() == [trademark]
    end

    test "get_trademark!/1 returns the trademark with given id" do
      trademark = trademark_fixture()
      assert Trademarks.get_trademark!(trademark.id) == trademark
    end

    test "create_trademark/1 with valid data creates a trademark" do
      assert {:ok, %Trademark{} = trademark} = Trademarks.create_trademark(@valid_attrs)
      assert trademark.name == "some name"
    end

    test "create_trademark/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trademarks.create_trademark(@invalid_attrs)
    end

    test "update_trademark/2 with valid data updates the trademark" do
      trademark = trademark_fixture()
      assert {:ok, trademark} = Trademarks.update_trademark(trademark, @update_attrs)
      assert %Trademark{} = trademark
      assert trademark.name == "some updated name"
    end

    test "update_trademark/2 with invalid data returns error changeset" do
      trademark = trademark_fixture()
      assert {:error, %Ecto.Changeset{}} = Trademarks.update_trademark(trademark, @invalid_attrs)
      assert trademark == Trademarks.get_trademark!(trademark.id)
    end

    test "delete_trademark/1 deletes the trademark" do
      trademark = trademark_fixture()
      assert {:ok, %Trademark{}} = Trademarks.delete_trademark(trademark)
      assert_raise Ecto.NoResultsError, fn -> Trademarks.get_trademark!(trademark.id) end
    end

    test "change_trademark/1 returns a trademark changeset" do
      trademark = trademark_fixture()
      assert %Ecto.Changeset{} = Trademarks.change_trademark(trademark)
    end
  end

  describe "attorneys" do
    alias Trademarks.Attorney

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def attorney_fixture(attrs \\ %{}) do
      {:ok, attorney} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trademarks.create_attorney()

      attorney
    end

    test "list_attorneys/0 returns all attorneys" do
      attorney = attorney_fixture()
      assert Trademarks.list_attorneys() == [attorney]
    end

    test "get_attorney!/1 returns the attorney with given id" do
      attorney = attorney_fixture()
      assert Trademarks.get_attorney!(attorney.id) == attorney
    end

    test "create_attorney/1 with valid data creates a attorney" do
      assert {:ok, %Attorney{} = attorney} = Trademarks.create_attorney(@valid_attrs)
      assert attorney.name == "some name"
    end

    test "create_attorney/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trademarks.create_attorney(@invalid_attrs)
    end

    test "update_attorney/2 with valid data updates the attorney" do
      attorney = attorney_fixture()
      assert {:ok, attorney} = Trademarks.update_attorney(attorney, @update_attrs)
      assert %Attorney{} = attorney
      assert attorney.name == "some updated name"
    end

    test "update_attorney/2 with invalid data returns error changeset" do
      attorney = attorney_fixture()
      assert {:error, %Ecto.Changeset{}} = Trademarks.update_attorney(attorney, @invalid_attrs)
      assert attorney == Trademarks.get_attorney!(attorney.id)
    end

    test "delete_attorney/1 deletes the attorney" do
      attorney = attorney_fixture()
      assert {:ok, %Attorney{}} = Trademarks.delete_attorney(attorney)
      assert_raise Ecto.NoResultsError, fn -> Trademarks.get_attorney!(attorney.id) end
    end

    test "change_attorney/1 returns a attorney changeset" do
      attorney = attorney_fixture()
      assert %Ecto.Changeset{} = Trademarks.change_attorney(attorney)
    end
  end

  describe "correspondents" do
    alias Trademarks.Correspondent

    @valid_attrs %{
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
    @invalid_attrs %{
      address_1: nil,
      address_2: nil,
      address_3: nil,
      address_4: nil,
      address_5: nil
    }

    def correspondent_fixture(attrs \\ %{}) do
      {:ok, correspondent} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trademarks.create_correspondent()

      correspondent
    end

    test "list_correspondents/0 returns all correspondents" do
      correspondent = correspondent_fixture()
      assert Trademarks.list_correspondents() == [correspondent]
    end

    test "get_correspondent!/1 returns the correspondent with given id" do
      correspondent = correspondent_fixture()
      assert Trademarks.get_correspondent!(correspondent.id) == correspondent
    end

    test "create_correspondent/1 with valid data creates a correspondent" do
      assert {:ok, %Correspondent{} = correspondent} =
               Trademarks.create_correspondent(@valid_attrs)

      assert correspondent.address_1 == "some address_1"
      assert correspondent.address_2 == "some address_2"
      assert correspondent.address_3 == "some address_3"
      assert correspondent.address_4 == "some address_4"
      assert correspondent.address_5 == "some address_5"
    end

    test "create_correspondent/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trademarks.create_correspondent(@invalid_attrs)
    end

    test "update_correspondent/2 with valid data updates the correspondent" do
      correspondent = correspondent_fixture()
      assert {:ok, correspondent} = Trademarks.update_correspondent(correspondent, @update_attrs)
      assert %Correspondent{} = correspondent
      assert correspondent.address_1 == "some updated address_1"
      assert correspondent.address_2 == "some updated address_2"
      assert correspondent.address_3 == "some updated address_3"
      assert correspondent.address_4 == "some updated address_4"
      assert correspondent.address_5 == "some updated address_5"
    end

    test "update_correspondent/2 with invalid data returns error changeset" do
      correspondent = correspondent_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Trademarks.update_correspondent(correspondent, @invalid_attrs)

      assert correspondent == Trademarks.get_correspondent!(correspondent.id)
    end

    test "delete_correspondent/1 deletes the correspondent" do
      correspondent = correspondent_fixture()
      assert {:ok, %Correspondent{}} = Trademarks.delete_correspondent(correspondent)
      assert_raise Ecto.NoResultsError, fn -> Trademarks.get_correspondent!(correspondent.id) end
    end

    test "change_correspondent/1 returns a correspondent changeset" do
      correspondent = correspondent_fixture()
      assert %Ecto.Changeset{} = Trademarks.change_correspondent(correspondent)
    end
  end

  describe "case_files" do
    alias Trademarks.CaseFile

    @valid_attrs %{
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

    def case_file_fixture(attrs \\ %{}) do
      {:ok, case_file} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trademarks.create_case_file()

      case_file
    end

    test "list_case_files/0 returns all case_files" do
      case_file = case_file_fixture()
      assert Trademarks.list_case_files() == [case_file]
    end

    test "get_case_file!/1 returns the case_file with given id" do
      case_file = case_file_fixture()
      assert Trademarks.get_case_file!(case_file.id) == case_file
    end

    test "create_case_file/1 with valid data creates a case_file" do
      assert {:ok, %CaseFile{} = case_file} = Trademarks.create_case_file(@valid_attrs)
      assert case_file.abandonment_date == ~D[2010-04-17]
      assert case_file.filing_date == ~D[2010-04-17]
      assert case_file.registration_date == ~D[2010-04-17]
      assert case_file.registration_number == "some registration_number"
      assert case_file.renewal_date == ~D[2010-04-17]
      assert case_file.serial_number == "some serial_number"
      assert case_file.status_date == ~D[2010-04-17]
    end

    test "create_case_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trademarks.create_case_file(@invalid_attrs)
    end

    test "update_case_file/2 with valid data updates the case_file" do
      case_file = case_file_fixture()
      assert {:ok, case_file} = Trademarks.update_case_file(case_file, @update_attrs)
      assert %CaseFile{} = case_file
      assert case_file.abandonment_date == ~D[2011-05-18]
      assert case_file.filing_date == ~D[2011-05-18]
      assert case_file.registration_date == ~D[2011-05-18]
      assert case_file.registration_number == "some updated registration_number"
      assert case_file.renewal_date == ~D[2011-05-18]
      assert case_file.serial_number == "some updated serial_number"
      assert case_file.status_date == ~D[2011-05-18]
    end

    test "update_case_file/2 with invalid data returns error changeset" do
      case_file = case_file_fixture()
      assert {:error, %Ecto.Changeset{}} = Trademarks.update_case_file(case_file, @invalid_attrs)
      assert case_file == Trademarks.get_case_file!(case_file.id)
    end

    test "delete_case_file/1 deletes the case_file" do
      case_file = case_file_fixture()
      assert {:ok, %CaseFile{}} = Trademarks.delete_case_file(case_file)
      assert_raise Ecto.NoResultsError, fn -> Trademarks.get_case_file!(case_file.id) end
    end

    test "change_case_file/1 returns a case_file changeset" do
      case_file = case_file_fixture()
      assert %Ecto.Changeset{} = Trademarks.change_case_file(case_file)
    end
  end

  describe "case_file_statements" do
    alias Trademarks.CaseFileStatement

    @valid_attrs %{description: "some description", type_code: "some type_code"}
    @update_attrs %{description: "some updated description", type_code: "some updated type_code"}
    @invalid_attrs %{description: nil, type_code: nil}

    def case_file_statement_fixture(attrs \\ %{}) do
      {:ok, case_file_statement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trademarks.create_case_file_statement()

      case_file_statement
    end

    test "list_case_file_statements/0 returns all case_file_statements" do
      case_file_statement = case_file_statement_fixture()
      assert Trademarks.list_case_file_statements() == [case_file_statement]
    end

    test "get_case_file_statement!/1 returns the case_file_statement with given id" do
      case_file_statement = case_file_statement_fixture()
      assert Trademarks.get_case_file_statement!(case_file_statement.id) == case_file_statement
    end

    test "create_case_file_statement/1 with valid data creates a case_file_statement" do
      assert {:ok, %CaseFileStatement{} = case_file_statement} =
               Trademarks.create_case_file_statement(@valid_attrs)

      assert case_file_statement.description == "some description"
      assert case_file_statement.type_code == "some type_code"
    end

    test "create_case_file_statement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trademarks.create_case_file_statement(@invalid_attrs)
    end

    test "update_case_file_statement/2 with valid data updates the case_file_statement" do
      case_file_statement = case_file_statement_fixture()

      assert {:ok, case_file_statement} =
               Trademarks.update_case_file_statement(case_file_statement, @update_attrs)

      assert %CaseFileStatement{} = case_file_statement
      assert case_file_statement.description == "some updated description"
      assert case_file_statement.type_code == "some updated type_code"
    end

    test "update_case_file_statement/2 with invalid data returns error changeset" do
      case_file_statement = case_file_statement_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Trademarks.update_case_file_statement(case_file_statement, @invalid_attrs)

      assert case_file_statement == Trademarks.get_case_file_statement!(case_file_statement.id)
    end

    test "delete_case_file_statement/1 deletes the case_file_statement" do
      case_file_statement = case_file_statement_fixture()

      assert {:ok, %CaseFileStatement{}} =
               Trademarks.delete_case_file_statement(case_file_statement)

      assert_raise Ecto.NoResultsError, fn ->
        Trademarks.get_case_file_statement!(case_file_statement.id)
      end
    end

    test "change_case_file_statement/1 returns a case_file_statement changeset" do
      case_file_statement = case_file_statement_fixture()
      assert %Ecto.Changeset{} = Trademarks.change_case_file_statement(case_file_statement)
    end
  end

  describe "case_file_event_statements" do
    alias Trademarks.CaseFileEventStatement

    @valid_attrs %{
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

    def case_file_event_statement_fixture(attrs \\ %{}) do
      {:ok, case_file_event_statement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trademarks.create_case_file_event_statement()

      case_file_event_statement
    end

    test "list_case_file_event_statements/0 returns all case_file_event_statements" do
      case_file_event_statement = case_file_event_statement_fixture()
      assert Trademarks.list_case_file_event_statements() == [case_file_event_statement]
    end

    test "get_case_file_event_statement!/1 returns the case_file_event_statement with given id" do
      case_file_event_statement = case_file_event_statement_fixture()

      assert Trademarks.get_case_file_event_statement!(case_file_event_statement.id) ==
               case_file_event_statement
    end

    test "create_case_file_event_statement/1 with valid data creates a case_file_event_statement" do
      assert {:ok, %CaseFileEventStatement{} = case_file_event_statement} =
               Trademarks.create_case_file_event_statement(@valid_attrs)

      assert case_file_event_statement.code == "some code"
      assert case_file_event_statement.date == ~D[2010-04-17]
      assert case_file_event_statement.description == "some description"
      assert case_file_event_statement.type == "some type"
    end

    test "create_case_file_event_statement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Trademarks.create_case_file_event_statement(@invalid_attrs)
    end

    test "update_case_file_event_statement/2 with valid data updates the case_file_event_statement" do
      case_file_event_statement = case_file_event_statement_fixture()

      assert {:ok, case_file_event_statement} =
               Trademarks.update_case_file_event_statement(
                 case_file_event_statement,
                 @update_attrs
               )

      assert %CaseFileEventStatement{} = case_file_event_statement
      assert case_file_event_statement.code == "some updated code"
      assert case_file_event_statement.date == ~D[2011-05-18]
      assert case_file_event_statement.description == "some updated description"
      assert case_file_event_statement.type == "some updated type"
    end

    test "update_case_file_event_statement/2 with invalid data returns error changeset" do
      case_file_event_statement = case_file_event_statement_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Trademarks.update_case_file_event_statement(
                 case_file_event_statement,
                 @invalid_attrs
               )

      assert case_file_event_statement ==
               Trademarks.get_case_file_event_statement!(case_file_event_statement.id)
    end

    test "delete_case_file_event_statement/1 deletes the case_file_event_statement" do
      case_file_event_statement = case_file_event_statement_fixture()

      assert {:ok, %CaseFileEventStatement{}} =
               Trademarks.delete_case_file_event_statement(case_file_event_statement)

      assert_raise Ecto.NoResultsError, fn ->
        Trademarks.get_case_file_event_statement!(case_file_event_statement.id)
      end
    end

    test "change_case_file_event_statement/1 returns a case_file_event_statement changeset" do
      case_file_event_statement = case_file_event_statement_fixture()

      assert %Ecto.Changeset{} =
               Trademarks.change_case_file_event_statement(case_file_event_statement)
    end
  end

  describe "case_file_owners" do
    alias Trademarks.CaseFileOwner

    @valid_attrs %{
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

    def case_file_owner_fixture(attrs \\ %{}) do
      {:ok, case_file_owner} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trademarks.create_case_file_owner()

      case_file_owner
    end

    test "list_case_file_owners/0 returns all case_file_owners" do
      case_file_owner = case_file_owner_fixture()
      assert Trademarks.list_case_file_owners() == [case_file_owner]
    end

    test "get_case_file_owner!/1 returns the case_file_owner with given id" do
      case_file_owner = case_file_owner_fixture()
      assert Trademarks.get_case_file_owner!(case_file_owner.id) == case_file_owner
    end

    test "create_case_file_owner/1 with valid data creates a case_file_owner" do
      assert {:ok, %CaseFileOwner{} = case_file_owner} =
               Trademarks.create_case_file_owner(@valid_attrs)

      assert case_file_owner.address_1 == "some address_1"
      assert case_file_owner.address_2 == "some address_2"
      assert case_file_owner.city == "some city"
      assert case_file_owner.country == "some country"
      assert case_file_owner.dba == "some dba"
      assert case_file_owner.nationality_country == "some nationality_country"
      assert case_file_owner.nationality_state == "some nationality_state"
      assert case_file_owner.party_name == "some party_name"
      assert case_file_owner.postcode == "some postcode"
      assert case_file_owner.state == "some state"
    end

    test "create_case_file_owner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trademarks.create_case_file_owner(@invalid_attrs)
    end

    test "update_case_file_owner/2 with valid data updates the case_file_owner" do
      case_file_owner = case_file_owner_fixture()

      assert {:ok, case_file_owner} =
               Trademarks.update_case_file_owner(case_file_owner, @update_attrs)

      assert %CaseFileOwner{} = case_file_owner
      assert case_file_owner.address_1 == "some updated address_1"
      assert case_file_owner.address_2 == "some updated address_2"
      assert case_file_owner.city == "some updated city"
      assert case_file_owner.country == "some updated country"
      assert case_file_owner.dba == "some updated dba"
      assert case_file_owner.nationality_country == "some updated nationality_country"
      assert case_file_owner.nationality_state == "some updated nationality_state"
      assert case_file_owner.party_name == "some updated party_name"
      assert case_file_owner.postcode == "some updated postcode"
      assert case_file_owner.state == "some updated state"
    end

    test "update_case_file_owner/2 with invalid data returns error changeset" do
      case_file_owner = case_file_owner_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Trademarks.update_case_file_owner(case_file_owner, @invalid_attrs)

      assert case_file_owner == Trademarks.get_case_file_owner!(case_file_owner.id)
    end

    test "delete_case_file_owner/1 deletes the case_file_owner" do
      case_file_owner = case_file_owner_fixture()
      assert {:ok, %CaseFileOwner{}} = Trademarks.delete_case_file_owner(case_file_owner)

      assert_raise Ecto.NoResultsError, fn ->
        Trademarks.get_case_file_owner!(case_file_owner.id)
      end
    end

    test "change_case_file_owner/1 returns a case_file_owner changeset" do
      case_file_owner = case_file_owner_fixture()
      assert %Ecto.Changeset{} = Trademarks.change_case_file_owner(case_file_owner)
    end
  end

  describe "case_files_case_file_owners" do
    alias Trademarks.CaseFilesCaseFileOwner

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def case_files_case_file_owner_fixture(attrs \\ %{}) do
      {:ok, case_files_case_file_owner} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trademarks.create_case_files_case_file_owner()

      case_files_case_file_owner
    end

    test "list_case_files_case_file_owners/0 returns all case_files_case_file_owners" do
      case_files_case_file_owner = case_files_case_file_owner_fixture()
      assert Trademarks.list_case_files_case_file_owners() == [case_files_case_file_owner]
    end

    test "get_case_files_case_file_owner!/1 returns the case_files_case_file_owner with given id" do
      case_files_case_file_owner = case_files_case_file_owner_fixture()

      assert Trademarks.get_case_files_case_file_owner!(case_files_case_file_owner.id) ==
               case_files_case_file_owner
    end

    test "create_case_files_case_file_owner/1 with valid data creates a case_files_case_file_owner" do
      assert {:ok, %CaseFilesCaseFileOwner{} = case_files_case_file_owner} =
               Trademarks.create_case_files_case_file_owner(@valid_attrs)
    end

    test "create_case_files_case_file_owner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Trademarks.create_case_files_case_file_owner(@invalid_attrs)
    end

    test "update_case_files_case_file_owner/2 with valid data updates the case_files_case_file_owner" do
      case_files_case_file_owner = case_files_case_file_owner_fixture()

      assert {:ok, case_files_case_file_owner} =
               Trademarks.update_case_files_case_file_owner(
                 case_files_case_file_owner,
                 @update_attrs
               )

      assert %CaseFilesCaseFileOwner{} = case_files_case_file_owner
    end

    test "update_case_files_case_file_owner/2 with invalid data returns error changeset" do
      case_files_case_file_owner = case_files_case_file_owner_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Trademarks.update_case_files_case_file_owner(
                 case_files_case_file_owner,
                 @invalid_attrs
               )

      assert case_files_case_file_owner ==
               Trademarks.get_case_files_case_file_owner!(case_files_case_file_owner.id)
    end

    test "delete_case_files_case_file_owner/1 deletes the case_files_case_file_owner" do
      case_files_case_file_owner = case_files_case_file_owner_fixture()

      assert {:ok, %CaseFilesCaseFileOwner{}} =
               Trademarks.delete_case_files_case_file_owner(case_files_case_file_owner)

      assert_raise Ecto.NoResultsError, fn ->
        Trademarks.get_case_files_case_file_owner!(case_files_case_file_owner.id)
      end
    end

    test "change_case_files_case_file_owner/1 returns a case_files_case_file_owner changeset" do
      case_files_case_file_owner = case_files_case_file_owner_fixture()

      assert %Ecto.Changeset{} =
               Trademarks.change_case_files_case_file_owner(case_files_case_file_owner)
    end
  end

  describe "case_file_owners_trademarks" do
    alias Trademarks.CaseFileOwnersTrademark

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def case_file_owners_trademark_fixture(attrs \\ %{}) do
      {:ok, case_file_owners_trademark} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trademarks.create_case_file_owners_trademark()

      case_file_owners_trademark
    end

    test "list_case_file_owners_trademarks/0 returns all case_file_owners_trademarks" do
      case_file_owners_trademark = case_file_owners_trademark_fixture()
      assert Trademarks.list_case_file_owners_trademarks() == [case_file_owners_trademark]
    end

    test "get_case_file_owners_trademark!/1 returns the case_file_owners_trademark with given id" do
      case_file_owners_trademark = case_file_owners_trademark_fixture()

      assert Trademarks.get_case_file_owners_trademark!(case_file_owners_trademark.id) ==
               case_file_owners_trademark
    end

    test "create_case_file_owners_trademark/1 with valid data creates a case_file_owners_trademark" do
      assert {:ok, %CaseFileOwnersTrademark{} = case_file_owners_trademark} =
               Trademarks.create_case_file_owners_trademark(@valid_attrs)
    end

    test "create_case_file_owners_trademark/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Trademarks.create_case_file_owners_trademark(@invalid_attrs)
    end

    test "update_case_file_owners_trademark/2 with valid data updates the case_file_owners_trademark" do
      case_file_owners_trademark = case_file_owners_trademark_fixture()

      assert {:ok, case_file_owners_trademark} =
               Trademarks.update_case_file_owners_trademark(
                 case_file_owners_trademark,
                 @update_attrs
               )

      assert %CaseFileOwnersTrademark{} = case_file_owners_trademark
    end

    test "update_case_file_owners_trademark/2 with invalid data returns error changeset" do
      case_file_owners_trademark = case_file_owners_trademark_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Trademarks.update_case_file_owners_trademark(
                 case_file_owners_trademark,
                 @invalid_attrs
               )

      assert case_file_owners_trademark ==
               Trademarks.get_case_file_owners_trademark!(case_file_owners_trademark.id)
    end

    test "delete_case_file_owners_trademark/1 deletes the case_file_owners_trademark" do
      case_file_owners_trademark = case_file_owners_trademark_fixture()

      assert {:ok, %CaseFileOwnersTrademark{}} =
               Trademarks.delete_case_file_owners_trademark(case_file_owners_trademark)

      assert_raise Ecto.NoResultsError, fn ->
        Trademarks.get_case_file_owners_trademark!(case_file_owners_trademark.id)
      end
    end

    test "change_case_file_owners_trademark/1 returns a case_file_owners_trademark changeset" do
      case_file_owners_trademark = case_file_owners_trademark_fixture()

      assert %Ecto.Changeset{} =
               Trademarks.change_case_file_owners_trademark(case_file_owners_trademark)
    end
  end
end
