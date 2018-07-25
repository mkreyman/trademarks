defmodule Trademarks.Models.Nodes.CaseFile do
  @moduledoc """
  CRUD operations for CaseFile nodes.
  """

  use Validators.ObjectKeyValidator
  use ApplicationErrors.Validator
  use Util.StructUtils
  use Util.PipeDebug

  import Neo4j.Core, only: [exec_query: 2]
  import Neo4j.NodeCore

  alias __MODULE__, warn: false
  alias Trademarks.Models.Nodes.Trademark

  defstruct [
    :serial_number,
    :abandonment_date,
    :filing_date,
    :registration_date,
    :registration_number,
    :renewal_date,
    :status_date,
    :label
  ]

  @type t :: %CaseFile{
          serial_number: String.t(),
          abandonment_date: integer,
          filing_date: integer,
          registration_date: integer,
          registration_number: String.t(),
          renewal_date: integer,
          status_date: integer,
          label: String.t()
        }

  def object_keys() do
    [:serial_number]
  end

  def empty_instance() do
    %CaseFile{label: struct_to_name()}
  end

  @doc """
  Find all case_files for a given Trademark.

  ## Parameters

    - trademark: the trademark to query for matching CaseFiles.

  ## Returns

    - A collection of case_files for a given Trademark.
  """
  def find_by_trademark(%Trademark{} = trademark) do
    "MATCH (tm:Trademark)<-[:FILED_FOR]-(cf:CaseFile) WHERE tm.name = \"#{trademark.name}\" RETURN cf"
    |> exec_query(empty_instance())
  end

  def find_by_trademark(%{name: _name} = trademark) do
    "MATCH (tm:Trademark)<-[:FILED_FOR]-(cf:CaseFile) WHERE tm.name = \"#{trademark.name}\" RETURN cf"
    |> exec_query(empty_instance())
  end

  @doc """
  CRUD create operation for CaseFile.

  ## Parameters

    - case_file: a CaseFile instance to store in the database.

  ## Returns

    CaseFile instance of the stored value.
  """
  def create(%CaseFile{serial_number: serial_number} = case_file) do
    """
      MERGE (cf:CaseFile {serial_number: \"#{serial_number}\"})
      ON CREATE SET cf.abandonment_date = toInt(\"#{case_file.abandonment_date}\"),
                    cf.filing_date = toInt(\"#{case_file.filing_date}\"),
                    cf.registration_date = toInt(\"#{case_file.registration_date}\"),
                    cf.registration_number = \"#{case_file.registration_number}\",
                    cf.renewal_date = toInt(\"#{case_file.renewal_date}\"),
                    cf.status_date = toInt(\"#{case_file.status_date}\"),
                    cf.label = \"#{struct_to_name()}\"
      RETURN cf
    """
    |> String.replace("\n", " ")
    |> exec_query(%CaseFile{})
  end

  @doc """
    Search operation for CaseFiles

    ## Parameters

      - case_file: a CaseFile instance with fields to use to search for matching instances in the database.

    ## Returns

      - A list of matching CaseFile instances.
  """
  def search(%CaseFile{} = case_file) do
    exec_search(case_file)
  end

  @doc """
  CRUD update operation for CaseFile.
  Note that the key data for the CaseFile will not be updated!  It is used only to update non-key fields.  To replace a
  CaseFile's key fields, delete and recreate the CaseFile.

  ## Parameters

    - case_file: a CaseFile instance to update in the database.

  ## Returns

    CaseFile instance of the updated value.
  """
  def update(%CaseFile{} = case_file) do
    exec_update(case_file)
  end

  @doc """
  CRUD delete operation for CaseFile.

  ## Parameters

    - case_file: a CaseFile instance to remove from the database.  Matches only on key data.

  ## Returns

    CaseFile instance of the dropped value.
  """
  def delete(%CaseFile{} = case_file) do
    exec_delete(case_file)
  end

  def delete(nil, _) do
    nil
  end

  @doc """
  CRUD read operation for CaseFile.

  ## Parameters

    - (overload) case_file: a CaseFile instance whose key values are used to find a CaseFile in the database.
    - (overload) case_files: A list of CaseFile instances whose key values are used to find matching CaseFiles in the database.

  ## Returns

    CaseFile instance of the matching value or nil if a single CaseFile is passed.
    A list of matching CaseFile instances or [] if a list of CaseFiles is passed.
  """
  def find(case_files) when is_list(case_files) do
    exec_find(case_files)
  end

  def find(%CaseFile{} = case_file) do
    exec_find(case_file)
  end

  def validate(%CaseFile{} = case_file) do
    case_file
  end
end
