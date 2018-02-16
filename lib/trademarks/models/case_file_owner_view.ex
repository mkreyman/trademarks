defmodule Trademarks.CaseFileOwnerView do
  use Ecto.Schema
  import Ecto.Query

  @primary_key false
  schema "case_file_owner_view" do
    field :owner_id, :binary_id
    field :owner_name, :string
    field :owner_address_1, :string
    field :owner_address_2, :string
    field :owner_city, :string
    field :owner_state, :string
    field :owner_postcode, :string
    field :case_file_id, :binary_id
    field :serial_number, :string
    field :registration_number, :string
    field :filing_date, :date
    field :registration_date, :date
    field :trademark, :string
    field :renewal_date, :date
    field :attorney, :string
    field :statements, :string
    field :event_statements, :string
    field :correspondent, :string
  end

  def owners(queryable \\ __MODULE__, params) do
    term = params[:trademark]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    queryable
    |> select([o],
      {o.trademark, o.owner_name,
                    o.owner_address_1, o.owner_address_2,
                    o.owner_city, o.owner_state, o.owner_postcode})
    |> where([o], ilike(o.trademark, ^query))
    |> order_by(desc: :filing_date)
  end

  def filter(queryable \\ __MODULE__, params) do
    queryable
    |> select([o],
      {o.trademark, o.owner_name,
                    o.owner_address_1, o.owner_address_2,
                    o.owner_city, o.owner_state, o.owner_postcode})
    |> where(^filter_where(params))
    |> order_by(desc: :filing_date)
  end

  def filter_where(params) do
    for key <- [:trademark, :owner_name],
        value = params[key],
    do: {key, value}
  end
end

# iex(10)> params7 = %{exact: false, owner_name: "Amazon Technologies, Inc."}
# %{exact: false, owner_name: "Amazon Technologies, Inc."}
# iex(11)> query = Trademarks.CaseFileOwnerView.filter(params7)
# #Ecto.Query<from c in Trademarks.CaseFileOwnerView,
#  where: c.owner_name == ^"Amazon Technologies, Inc.",
#  order_by: [desc: c.filing_date],
#  select: {c.trademark, c.owner_name, c.owner_address_1, c.owner_address_2, c.owner_city, c.owner_state, c.owner_postcode}>
# iex(12)> Trademarks.Repo.all query

# iex(17)> params9 = %{exact: false, trademark: "prime"}
# %{exact: false, trademark: "prime"}
# iex(20)> query = Trademarks.CaseFileView.owners(params9)
# #Ecto.Query<from c in Trademarks.CaseFileView,
#  where: ilike(c.trademark, ^"%prime%"), order_by: [desc: c.filing_date],
#  select: {c.trademark, c.owner_name, c.owner_address_1, c.owner_address_2, c.owner_city, c.owner_state, c.owner_postcode}>
# iex(21)> Trademarks.Repo.all query