defmodule Trademarks.CaseFileOwnersTrademark do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{CaseFileOwner, Trademark}

  @primary_key false
  schema "case_file_owners_trademarks" do
    belongs_to :case_file_owner, CaseFileOwner, type: :binary_id, on_replace: :delete
    belongs_to :trademark, Trademark, type: :binary_id, on_replace: :delete
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:case_file_owner_id, :trademark_id])
    |> validate_required([:case_file_owner_id, :trademark_id])
    |> foreign_key_constraint(:case_file_owner_id)
    |> foreign_key_constraint(:trademark_id)
    |> unique_constraint(:case_file_owner_id_trademark_id_index)
  end
end