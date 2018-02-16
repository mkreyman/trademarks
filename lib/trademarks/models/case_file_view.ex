defmodule Trademarks.CaseFileView do
  use Ecto.Schema
  import Ecto.Query

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
    field :statements, :string
    field :event_statements, :string
    field :correspondent, :string
    field :owner_id, :binary_id
    field :owner_name, :string
    field :owner_address_1, :string
    field :owner_address_2, :string
    field :owner_city, :string
    field :owner_state, :string
    field :owner_postcode, :string
  end

  def trademarks(queryable \\ __MODULE__, params) do
    term = params[:trademark]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    queryable
    |> where([cf], ilike(cf.trademark, ^query))
    |> order_by(desc: :filing_date)
  end

  def owners(queryable \\ __MODULE__, params) do
    term = params[:trademark]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    queryable
    |> select([cf],
      {cf.trademark, cf.owner_name,
                     cf.owner_address_1, cf.owner_address_2,
                     cf.owner_city, cf.owner_state, cf.owner_postcode})
    |> where([cf], ilike(cf.trademark, ^query))
    |> order_by(desc: :filing_date)
  end

  def filter(queryable \\ __MODULE__, params) do
    queryable
    |> select([cf],
      {cf.trademark, cf.owner_name,
                     cf.owner_address_1, cf.owner_address_2,
                     cf.owner_city, cf.owner_state, cf.owner_postcode})
    |> where(^filter_where(params))
    |> order_by(desc: :filing_date)
  end

  def filter_where(params) do
    for key <- [:trademark, :owner_name],
        value = params[key],
    do: {key, value}
  end

  # WIP
  # def filter_where(params) do
  #   for key <- [:trademark, :owner_name],
  #       value = params[key] do
  #         case params[:exact] do
  #           true -> "#{key} ILIKE #{value}"
  #           _    -> "#{key} ILIKE %#{value}%"
  #         end
  #       end
  # end
end

# iex(13)> params8 = %{trademark: "PRIME"}
# %{trademark: "PRIME"}
# iex(14)> query = Trademarks.CaseFileView.filter(params8)
# #Ecto.Query<from c in Trademarks.CaseFileView, where: c.trademark == ^"PRIME",
#  order_by: [desc: c.filing_date],
#  select: {c.trademark, c.owner_name, c.owner_address_1, c.owner_address_2, c.owner_city, c.owner_state, c.owner_postcode}>
# iex(15)> Trademarks.Repo.all query
# [
#   {"PRIME", "Amazon Technologies, Inc.", "Attn: Trademarks", "410 Terry Ave N",
#    "Seattle", "WA", "98109"}
# ]