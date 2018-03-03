defmodule Trademarks.CaseFilesCaseFileOwner do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{CaseFile, CaseFileOwner}

  @primary_key false
  schema "case_files_case_file_owners" do
    belongs_to(:case_file, CaseFile, type: :binary_id, on_replace: :delete)
    belongs_to(:case_file_owner, CaseFileOwner, type: :binary_id, on_replace: :delete)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:case_file_id, :case_file_owner_id])
    |> validate_required([:case_file_id, :case_file_owner_id])
    |> foreign_key_constraint(:case_file_id)
    |> foreign_key_constraint(:case_file_owner_id)
    |> unique_constraint(:case_file_id_case_file_owner_id_index)
  end
end
