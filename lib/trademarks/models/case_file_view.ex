defmodule Trademarks.CaseFileView do
  use Ecto.Schema
  import Ecto.Query

  alias Trademarks.{
    CaseFileOwner,
    CaseFilesCaseFileOwner,
    Repo
  }

  @primary_key false
  schema "case_file_view" do
    field :case_file_id, :binary_id
    field :serial_number, :string
    field :registration_number, :string
    field :filing_date, :date
    field :registration_date, :date
    field :trademark, :string
    field :renewal_date, :date
    field :attorney, :string
    many_to_many :case_file_owners, CaseFileOwner,
                 join_through: CaseFilesCaseFileOwner,
                 join_keys: [case_file_id: :case_file_id, case_file_owner_id: :id]
  end

  def find(queryable \\ __MODULE__, params) do
    term = params[:trademark]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    queryable
    |> where([cf], ilike(cf.trademark, ^query))
    |> order_by(desc: :filing_date)
    |> preload(:case_file_owners)
    |> Repo.all
  end

end