defmodule Trademarks.CaseFile do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trademarks.{
    CaseFileStatement,
    CaseFileEventStatement,
    CaseFileOwner,
    Correspondent
    }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "case_files" do
    field :serial_number,       :string
    field :registration_number, :string
    field :filing_date,         :date
    field :registration_date,   :date
    field :mark_identification, :string
    field :attorney_name,       :string
    field :renewal_date,        :date
    has_many :case_file_statements, CaseFileStatement, on_delete: :delete_all
    has_many :case_file_event_statements, CaseFileEventStatement, on_delete: :delete_all
    has_many :case_file_owners, CaseFileOwner, on_delete: :delete_all
    has_one  :correspondent, Correspondent, on_delete: :delete_all

    timestamps
  end

  @fields ~w(serial_number
             registration_number
             filing_date
             registration_date
             mark_identification
             attorney_name
             renewal_date
            )

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:mark_identification])
  end
end