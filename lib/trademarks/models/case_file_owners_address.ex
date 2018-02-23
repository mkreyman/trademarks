defmodule Trademarks.CaseFileOwnersAddress do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{CaseFileOwner, Address}

  @primary_key false
  schema "case_file_owners_addresses" do
    belongs_to :case_file_owner, CaseFileOwner, type: :binary_id, on_replace: :delete
    belongs_to :address, Address, type: :binary_id, on_replace: :delete
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:case_file_owner_id, :address_id])
    |> validate_required([:case_file_owner_id, :address_id])
    |> foreign_key_constraint(:case_file_owner_id)
    |> foreign_key_constraint(:address_id)
    |> unique_constraint(:case_file_owner_id_address_id_index)
  end
end