defmodule Trademarks do
  @moduledoc """
  The Trademarks context.
  """

  import Ecto.Query, warn: false
  alias Trademarks.Repo

  alias Trademarks.Trademark

  @doc """
  Returns the list of trademarks.

  ## Examples

      iex> list_trademarks()
      [%Trademark{}, ...]

  """
  def list_trademarks do
    Repo.all(Trademark)
  end

  @doc """
  Gets a single trademark.

  Raises `Ecto.NoResultsError` if the Trademark does not exist.

  ## Examples

      iex> get_trademark!(123)
      %Trademark{}

      iex> get_trademark!(456)
      ** (Ecto.NoResultsError)

  """
  def get_trademark!(id), do: Repo.get!(Trademark, id)

  @doc """
  Creates a trademark.

  ## Examples

      iex> create_trademark(%{field: value})
      {:ok, %Trademark{}}

      iex> create_trademark(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_trademark(attrs \\ %{}) do
    %Trademark{}
    |> Trademark.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a trademark.

  ## Examples

      iex> update_trademark(trademark, %{field: new_value})
      {:ok, %Trademark{}}

      iex> update_trademark(trademark, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_trademark(%Trademark{} = trademark, attrs) do
    trademark
    |> Trademark.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Trademark.

  ## Examples

      iex> delete_trademark(trademark)
      {:ok, %Trademark{}}

      iex> delete_trademark(trademark)
      {:error, %Ecto.Changeset{}}

  """
  def delete_trademark(%Trademark{} = trademark) do
    Repo.delete(trademark)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trademark changes.

  ## Examples

      iex> change_trademark(trademark)
      %Ecto.Changeset{source: %Trademark{}}

  """
  def change_trademark(%Trademark{} = trademark) do
    Trademark.changeset(trademark, %{})
  end

  alias Trademarks.Attorney

  @doc """
  Returns the list of attorneys.

  ## Examples

      iex> list_attorneys()
      [%Attorney{}, ...]

  """
  def list_attorneys do
    Repo.all(Attorney)
  end

  @doc """
  Gets a single attorney.

  Raises `Ecto.NoResultsError` if the Attorney does not exist.

  ## Examples

      iex> get_attorney!(123)
      %Attorney{}

      iex> get_attorney!(456)
      ** (Ecto.NoResultsError)

  """
  def get_attorney!(id), do: Repo.get!(Attorney, id)

  @doc """
  Creates a attorney.

  ## Examples

      iex> create_attorney(%{field: value})
      {:ok, %Attorney{}}

      iex> create_attorney(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_attorney(attrs \\ %{}) do
    %Attorney{}
    |> Attorney.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a attorney.

  ## Examples

      iex> update_attorney(attorney, %{field: new_value})
      {:ok, %Attorney{}}

      iex> update_attorney(attorney, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_attorney(%Attorney{} = attorney, attrs) do
    attorney
    |> Attorney.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Attorney.

  ## Examples

      iex> delete_attorney(attorney)
      {:ok, %Attorney{}}

      iex> delete_attorney(attorney)
      {:error, %Ecto.Changeset{}}

  """
  def delete_attorney(%Attorney{} = attorney) do
    Repo.delete(attorney)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attorney changes.

  ## Examples

      iex> change_attorney(attorney)
      %Ecto.Changeset{source: %Attorney{}}

  """
  def change_attorney(%Attorney{} = attorney) do
    Attorney.changeset(attorney, %{})
  end

  alias Trademarks.Correspondent

  @doc """
  Returns the list of correspondents.

  ## Examples

      iex> list_correspondents()
      [%Correspondent{}, ...]

  """
  def list_correspondents do
    Repo.all(Correspondent)
  end

  @doc """
  Gets a single correspondent.

  Raises `Ecto.NoResultsError` if the Correspondent does not exist.

  ## Examples

      iex> get_correspondent!(123)
      %Correspondent{}

      iex> get_correspondent!(456)
      ** (Ecto.NoResultsError)

  """
  def get_correspondent!(id), do: Repo.get!(Correspondent, id)

  @doc """
  Creates a correspondent.

  ## Examples

      iex> create_correspondent(%{field: value})
      {:ok, %Correspondent{}}

      iex> create_correspondent(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_correspondent(attrs \\ %{}) do
    %Correspondent{}
    |> Correspondent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a correspondent.

  ## Examples

      iex> update_correspondent(correspondent, %{field: new_value})
      {:ok, %Correspondent{}}

      iex> update_correspondent(correspondent, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_correspondent(%Correspondent{} = correspondent, attrs) do
    correspondent
    |> Correspondent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Correspondent.

  ## Examples

      iex> delete_correspondent(correspondent)
      {:ok, %Correspondent{}}

      iex> delete_correspondent(correspondent)
      {:error, %Ecto.Changeset{}}

  """
  def delete_correspondent(%Correspondent{} = correspondent) do
    Repo.delete(correspondent)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking correspondent changes.

  ## Examples

      iex> change_correspondent(correspondent)
      %Ecto.Changeset{source: %Correspondent{}}

  """
  def change_correspondent(%Correspondent{} = correspondent) do
    Correspondent.changeset(correspondent, %{})
  end

  alias Trademarks.CaseFile

  @doc """
  Returns the list of case_files.

  ## Examples

      iex> list_case_files()
      [%CaseFile{}, ...]

  """
  def list_case_files do
    Repo.all(CaseFile)
  end

  @doc """
  Gets a single case_file.

  Raises `Ecto.NoResultsError` if the Case file does not exist.

  ## Examples

      iex> get_case_file!(123)
      %CaseFile{}

      iex> get_case_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_case_file!(id), do: Repo.get!(CaseFile, id)

  @doc """
  Creates a case_file.

  ## Examples

      iex> create_case_file(%{field: value})
      {:ok, %CaseFile{}}

      iex> create_case_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_case_file(attrs \\ %{}) do
    %CaseFile{}
    |> CaseFile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a case_file.

  ## Examples

      iex> update_case_file(case_file, %{field: new_value})
      {:ok, %CaseFile{}}

      iex> update_case_file(case_file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_case_file(%CaseFile{} = case_file, attrs) do
    case_file
    |> CaseFile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CaseFile.

  ## Examples

      iex> delete_case_file(case_file)
      {:ok, %CaseFile{}}

      iex> delete_case_file(case_file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_case_file(%CaseFile{} = case_file) do
    Repo.delete(case_file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking case_file changes.

  ## Examples

      iex> change_case_file(case_file)
      %Ecto.Changeset{source: %CaseFile{}}

  """
  def change_case_file(%CaseFile{} = case_file) do
    CaseFile.changeset(case_file, %{})
  end

  alias Trademarks.CaseFileStatement

  @doc """
  Returns the list of case_file_statements.

  ## Examples

      iex> list_case_file_statements()
      [%CaseFileStatement{}, ...]

  """
  def list_case_file_statements do
    Repo.all(CaseFileStatement)
  end

  @doc """
  Gets a single case_file_statement.

  Raises `Ecto.NoResultsError` if the Case file statement does not exist.

  ## Examples

      iex> get_case_file_statement!(123)
      %CaseFileStatement{}

      iex> get_case_file_statement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_case_file_statement!(id), do: Repo.get!(CaseFileStatement, id)

  @doc """
  Creates a case_file_statement.

  ## Examples

      iex> create_case_file_statement(%{field: value})
      {:ok, %CaseFileStatement{}}

      iex> create_case_file_statement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_case_file_statement(attrs \\ %{}) do
    %CaseFileStatement{}
    |> CaseFileStatement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a case_file_statement.

  ## Examples

      iex> update_case_file_statement(case_file_statement, %{field: new_value})
      {:ok, %CaseFileStatement{}}

      iex> update_case_file_statement(case_file_statement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_case_file_statement(%CaseFileStatement{} = case_file_statement, attrs) do
    case_file_statement
    |> CaseFileStatement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CaseFileStatement.

  ## Examples

      iex> delete_case_file_statement(case_file_statement)
      {:ok, %CaseFileStatement{}}

      iex> delete_case_file_statement(case_file_statement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_case_file_statement(%CaseFileStatement{} = case_file_statement) do
    Repo.delete(case_file_statement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking case_file_statement changes.

  ## Examples

      iex> change_case_file_statement(case_file_statement)
      %Ecto.Changeset{source: %CaseFileStatement{}}

  """
  def change_case_file_statement(%CaseFileStatement{} = case_file_statement) do
    CaseFileStatement.changeset(case_file_statement, %{})
  end

  alias Trademarks.CaseFileEventStatement

  @doc """
  Returns the list of case_file_event_statements.

  ## Examples

      iex> list_case_file_event_statements()
      [%CaseFileEventStatement{}, ...]

  """
  def list_case_file_event_statements do
    Repo.all(CaseFileEventStatement)
  end

  @doc """
  Gets a single case_file_event_statement.

  Raises `Ecto.NoResultsError` if the Case file event statement does not exist.

  ## Examples

      iex> get_case_file_event_statement!(123)
      %CaseFileEventStatement{}

      iex> get_case_file_event_statement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_case_file_event_statement!(id), do: Repo.get!(CaseFileEventStatement, id)

  @doc """
  Creates a case_file_event_statement.

  ## Examples

      iex> create_case_file_event_statement(%{field: value})
      {:ok, %CaseFileEventStatement{}}

      iex> create_case_file_event_statement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_case_file_event_statement(attrs \\ %{}) do
    %CaseFileEventStatement{}
    |> CaseFileEventStatement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a case_file_event_statement.

  ## Examples

      iex> update_case_file_event_statement(case_file_event_statement, %{field: new_value})
      {:ok, %CaseFileEventStatement{}}

      iex> update_case_file_event_statement(case_file_event_statement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_case_file_event_statement(
        %CaseFileEventStatement{} = case_file_event_statement,
        attrs
      ) do
    case_file_event_statement
    |> CaseFileEventStatement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CaseFileEventStatement.

  ## Examples

      iex> delete_case_file_event_statement(case_file_event_statement)
      {:ok, %CaseFileEventStatement{}}

      iex> delete_case_file_event_statement(case_file_event_statement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_case_file_event_statement(%CaseFileEventStatement{} = case_file_event_statement) do
    Repo.delete(case_file_event_statement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking case_file_event_statement changes.

  ## Examples

      iex> change_case_file_event_statement(case_file_event_statement)
      %Ecto.Changeset{source: %CaseFileEventStatement{}}

  """
  def change_case_file_event_statement(%CaseFileEventStatement{} = case_file_event_statement) do
    CaseFileEventStatement.changeset(case_file_event_statement, %{})
  end

  alias Trademarks.CaseFileOwner

  @doc """
  Returns the list of case_file_owners.

  ## Examples

      iex> list_case_file_owners()
      [%CaseFileOwner{}, ...]

  """
  def list_case_file_owners do
    Repo.all(CaseFileOwner)
  end

  @doc """
  Gets a single case_file_owner.

  Raises `Ecto.NoResultsError` if the Case file owner does not exist.

  ## Examples

      iex> get_case_file_owner!(123)
      %CaseFileOwner{}

      iex> get_case_file_owner!(456)
      ** (Ecto.NoResultsError)

  """
  def get_case_file_owner!(id), do: Repo.get!(CaseFileOwner, id)

  @doc """
  Creates a case_file_owner.

  ## Examples

      iex> create_case_file_owner(%{field: value})
      {:ok, %CaseFileOwner{}}

      iex> create_case_file_owner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_case_file_owner(attrs \\ %{}) do
    %CaseFileOwner{}
    |> CaseFileOwner.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a case_file_owner.

  ## Examples

      iex> update_case_file_owner(case_file_owner, %{field: new_value})
      {:ok, %CaseFileOwner{}}

      iex> update_case_file_owner(case_file_owner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_case_file_owner(%CaseFileOwner{} = case_file_owner, attrs) do
    case_file_owner
    |> CaseFileOwner.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CaseFileOwner.

  ## Examples

      iex> delete_case_file_owner(case_file_owner)
      {:ok, %CaseFileOwner{}}

      iex> delete_case_file_owner(case_file_owner)
      {:error, %Ecto.Changeset{}}

  """
  def delete_case_file_owner(%CaseFileOwner{} = case_file_owner) do
    Repo.delete(case_file_owner)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking case_file_owner changes.

  ## Examples

      iex> change_case_file_owner(case_file_owner)
      %Ecto.Changeset{source: %CaseFileOwner{}}

  """
  def change_case_file_owner(%CaseFileOwner{} = case_file_owner) do
    CaseFileOwner.changeset(case_file_owner, %{})
  end

  alias Trademarks.CaseFilesCaseFileOwner

  @doc """
  Returns the list of case_files_case_file_owners.

  ## Examples

      iex> list_case_files_case_file_owners()
      [%CaseFilesCaseFileOwner{}, ...]

  """
  def list_case_files_case_file_owners do
    Repo.all(CaseFilesCaseFileOwner)
  end

  @doc """
  Gets a single case_files_case_file_owner.

  Raises `Ecto.NoResultsError` if the Case files case file owner does not exist.

  ## Examples

      iex> get_case_files_case_file_owner!(123)
      %CaseFilesCaseFileOwner{}

      iex> get_case_files_case_file_owner!(456)
      ** (Ecto.NoResultsError)

  """
  def get_case_files_case_file_owner!(id), do: Repo.get!(CaseFilesCaseFileOwner, id)

  @doc """
  Creates a case_files_case_file_owner.

  ## Examples

      iex> create_case_files_case_file_owner(%{field: value})
      {:ok, %CaseFilesCaseFileOwner{}}

      iex> create_case_files_case_file_owner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_case_files_case_file_owner(attrs \\ %{}) do
    %CaseFilesCaseFileOwner{}
    |> CaseFilesCaseFileOwner.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a case_files_case_file_owner.

  ## Examples

      iex> update_case_files_case_file_owner(case_files_case_file_owner, %{field: new_value})
      {:ok, %CaseFilesCaseFileOwner{}}

      iex> update_case_files_case_file_owner(case_files_case_file_owner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_case_files_case_file_owner(
        %CaseFilesCaseFileOwner{} = case_files_case_file_owner,
        attrs
      ) do
    case_files_case_file_owner
    |> CaseFilesCaseFileOwner.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CaseFilesCaseFileOwner.

  ## Examples

      iex> delete_case_files_case_file_owner(case_files_case_file_owner)
      {:ok, %CaseFilesCaseFileOwner{}}

      iex> delete_case_files_case_file_owner(case_files_case_file_owner)
      {:error, %Ecto.Changeset{}}

  """
  def delete_case_files_case_file_owner(%CaseFilesCaseFileOwner{} = case_files_case_file_owner) do
    Repo.delete(case_files_case_file_owner)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking case_files_case_file_owner changes.

  ## Examples

      iex> change_case_files_case_file_owner(case_files_case_file_owner)
      %Ecto.Changeset{source: %CaseFilesCaseFileOwner{}}

  """
  def change_case_files_case_file_owner(%CaseFilesCaseFileOwner{} = case_files_case_file_owner) do
    CaseFilesCaseFileOwner.changeset(case_files_case_file_owner, %{})
  end

  alias Trademarks.CaseFileOwnersTrademark

  @doc """
  Returns the list of case_file_owners_trademarks.

  ## Examples

      iex> list_case_file_owners_trademarks()
      [%CaseFileOwnersTrademark{}, ...]

  """
  def list_case_file_owners_trademarks do
    Repo.all(CaseFileOwnersTrademark)
  end

  @doc """
  Gets a single case_file_owners_trademark.

  Raises `Ecto.NoResultsError` if the Case file owners trademark does not exist.

  ## Examples

      iex> get_case_file_owners_trademark!(123)
      %CaseFileOwnersTrademark{}

      iex> get_case_file_owners_trademark!(456)
      ** (Ecto.NoResultsError)

  """
  def get_case_file_owners_trademark!(id), do: Repo.get!(CaseFileOwnersTrademark, id)

  @doc """
  Creates a case_file_owners_trademark.

  ## Examples

      iex> create_case_file_owners_trademark(%{field: value})
      {:ok, %CaseFileOwnersTrademark{}}

      iex> create_case_file_owners_trademark(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_case_file_owners_trademark(attrs \\ %{}) do
    %CaseFileOwnersTrademark{}
    |> CaseFileOwnersTrademark.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a case_file_owners_trademark.

  ## Examples

      iex> update_case_file_owners_trademark(case_file_owners_trademark, %{field: new_value})
      {:ok, %CaseFileOwnersTrademark{}}

      iex> update_case_file_owners_trademark(case_file_owners_trademark, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_case_file_owners_trademark(
        %CaseFileOwnersTrademark{} = case_file_owners_trademark,
        attrs
      ) do
    case_file_owners_trademark
    |> CaseFileOwnersTrademark.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CaseFileOwnersTrademark.

  ## Examples

      iex> delete_case_file_owners_trademark(case_file_owners_trademark)
      {:ok, %CaseFileOwnersTrademark{}}

      iex> delete_case_file_owners_trademark(case_file_owners_trademark)
      {:error, %Ecto.Changeset{}}

  """
  def delete_case_file_owners_trademark(%CaseFileOwnersTrademark{} = case_file_owners_trademark) do
    Repo.delete(case_file_owners_trademark)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking case_file_owners_trademark changes.

  ## Examples

      iex> change_case_file_owners_trademark(case_file_owners_trademark)
      %Ecto.Changeset{source: %CaseFileOwnersTrademark{}}

  """
  def change_case_file_owners_trademark(%CaseFileOwnersTrademark{} = case_file_owners_trademark) do
    CaseFileOwnersTrademark.changeset(case_file_owners_trademark, %{})
  end
end
