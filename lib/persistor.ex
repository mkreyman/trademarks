defmodule Trademarks.Persistor do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Trademarks.{
    Attorney,
    CaseFile,
    Trademark,
    CaseFileOwnersTrademark,
    CaseFileStatement,
    CaseFileEventStatement,
    Correspondent,
    CaseFileOwner,
    CaseFilesCaseFileOwner,
    Repo
  }

  def process(stream) do
    started = :os.system_time(:seconds)

    number_of_case_files_before = Repo.one(from(cf in "case_files", select: count(cf.id)))

    number_of_case_file_owners_before =
      Repo.one(from(cfo in "case_file_owners", select: count(cfo.id)))

    number_of_trademarks_before = Repo.one(from(cfo in "trademarks", select: count(cfo.id)))

    Logger.info("Started processing ...")

    # subset = 3
    stream
    # |> Stream.take(subset)
    |> Enum.map(&save(&1))

    finished = :os.system_time(:seconds)
    number_of_case_files_now = Trademarks.Repo.one(from(cf in "case_files", select: count(cf.id)))
    new_case_files = number_of_case_files_now - number_of_case_files_before

    number_of_case_file_owners_now =
      Repo.one(from(cfo in "case_file_owners", select: count(cfo.id)))

    new_case_file_owners = number_of_case_file_owners_now - number_of_case_file_owners_before

    number_of_trademarks_now = Repo.one(from(cfo in "trademarks", select: count(cfo.id)))

    new_trademarks = number_of_trademarks_now - number_of_trademarks_before

    Logger.info(fn ->
      """
      There were #{number_of_trademarks_before} trademarks, #{number_of_case_files_before} existing case files and
      #{number_of_case_file_owners_before} case file owners. Processed #{new_case_files} new case files,
      #{new_trademarks} trademarks and #{new_case_file_owners} new case file owners in #{
        finished - started
      } secs\n
      """
    end)
  end

  defp save(params) do
    with {:ok, case_file} <- CaseFile.create_or_update(params),
         {:ok, trademark_id} <- Trademark.create_or_update(params) do
      case_file
      |> Repo.preload([
        :attorney,
        :correspondent,
        :trademark,
        :case_file_statements,
        :case_file_event_statements,
        :case_file_owners
      ])
      |> associate_owners_and_trademarks(params, trademark_id)
      |> CaseFile.changeset(params)
      |> put_change(:attorney_id, Attorney.create_or_update(params))
      |> put_change(:correspondent_id, Correspondent.create_or_update(params[:correspondent]))
      |> put_change(:trademark_id, trademark_id)
      |> put_change(
        :case_file_statements,
        CaseFileStatement.create_or_update_all(params[:case_file_statements], case_file)
      )
      |> put_change(
        :case_file_event_statements,
        CaseFileEventStatement.create_or_update_all(
          params[:case_file_event_statements],
          case_file
        )
      )
      |> Repo.insert_or_update()
      |> case do
        {:ok, case_file} -> {:ok, case_file}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, changeset} ->
        Logger.error(fn ->
          """
          Invalid changeset for serial number: #{inspect(params[:serial_number])}
          and trademark: #{inspect(params[:trademark_name])},
          params: #{inspect(params)},
          changeset: #{inspect(changeset)}
          """
        end)

      _ ->
        Logger.error(fn ->
          "Persistor: Something went wrong with params: #{inspect(params)}"
        end)
    end
  end

  defp associate_owners_and_trademarks(case_file, params, trademark_id) do
    params[:case_file_owners]
    |> Enum.map(&CaseFileOwner.create_or_update/1)
    |> Enum.map(fn {:ok, case_file_owner} -> case_file_owner end)
    |> Enum.map(fn case_file_owner ->
      associate_with_case_file(case_file.id, case_file_owner.id)
      associate_with_trademark(trademark_id, case_file_owner.id)
    end)

    case_file
  end

  defp associate_with_case_file(case_file_id, case_file_owner_id) do
    %CaseFilesCaseFileOwner{}
    |> CaseFilesCaseFileOwner.changeset(%{
      case_file_id: case_file_id,
      case_file_owner_id: case_file_owner_id
    })
    |> Repo.insert(on_conflict: :nothing)
  end

  defp associate_with_trademark(trademark_id, case_file_owner_id) do
    %CaseFileOwnersTrademark{}
    |> CaseFileOwnersTrademark.changeset(%{
      trademark_id: trademark_id,
      case_file_owner_id: case_file_owner_id
    })
    |> Repo.insert(on_conflict: :nothing)
  end
end
