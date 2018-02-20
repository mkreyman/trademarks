defmodule Trademarks.Search do
  import Ecto.Query

  alias Trademarks.{
    Attorney,
    CaseFile,
    Correspondent,
    CaseFileOwner,
    CaseFileOwnerView,
    Repo
  }

  def by_attorney(params) do
    term = params[:attorney]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    Attorney
    |> where([a], ilike(a.name, ^query))
    |> order_by(asc: :name)
    |> preload(:case_files)
    |> Repo.all
  end

  def by_trademark(params) do
    term = params[:trademark]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    CaseFile
    |> where([cf], ilike(cf.trademark, ^query))
    |> order_by(desc: :filing_date)
    |> preload(:attorney)
    |> preload(:case_file_statements)
    |> preload(:case_file_event_statements)
    |> preload(:correspondent)
    |> preload(:case_file_owners)
    |> Repo.all
  end

  def by_owner(params) do
    term = params[:party_name]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    Repo.all from o in CaseFileOwner,
               where: ilike(o.party_name, ^query),
               join: cf in assoc(o, :case_files),
               join: a in assoc(o, :attorney),
               join: c in assoc(o, :correspondent),
               preload: [case_files: cf],
               preload: [attorney: a],
               preload: [correspondent: c],
               select: [:id, :party_name, :address_1, :address_2, :city, :state, :postcode,
                        case_files: [:id, :serial_number, :registration_number, :filing_date,
                                     :registration_date, :trademark, :renewal_date],
                        attorney: [:id, :name],
                        correspondent: [:id, :address_1, :address_2, :address_3, :address_4]]
  end

  def by_owner_view(params) do
    term = params[:owner_name]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    CaseFileOwnerView
    |> where([o], ilike(o.owner_name, ^query))
    |> Repo.all
  end

  def by_correspondent(params) do
    term = params[:correspondent]
    query = "%#{term}%"
    Correspondent
    |> where([c], ilike(c.address_1, ^query))
    |> order_by(asc: :address_1)
    |> preload(:case_files)
    |> Repo.all
  end
end