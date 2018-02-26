defmodule Trademarks.Search do
  import Ecto.Query

  alias Trademarks.{
    Attorney,
    CaseFile,
    Correspondent,
    CaseFileOwner,
    Repo
  }

  def by_attorney(params) do
    term = params[:attorney]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    Repo.all from(attorney in Attorney,
               where: ilike(attorney.name, ^query),
               left_join: f in assoc(attorney, :case_files),
               left_join: c in assoc(f, :correspondent),
               left_join: o in assoc(f, :case_file_owners),
               left_join: a in assoc(o, :addresses),
               preload: [case_files: {f,
                         correspondent: c,
                         case_file_owners: {o, addresses: a}}],
               select: map(attorney, [:id, :name,
                           case_files: [:id, :abandonment_date, :filing_date, :registration_date, :registration_number,
                             :renewal_date, :serial_number, :status_date, :trademark,
                             correspondent: [:id, :address_1, :address_2, :address_3, :address_4, :address_5],
                             case_file_owners: [:id, :dba, :nationality_country, :nationality_state, :party_name,
                                                addresses: [:id, :address_1, :address_2, :city, :state, :postcode, :country]]]]))
  end

  def by_trademark(params) do
    term = params[:trademark]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    Repo.all from(f in CaseFile,
               where: ilike(f.trademark, ^query),
               left_join: att in assoc(f, :attorney),
               left_join: c in assoc(f, :correspondent),
               left_join: cfs in assoc(f, :case_file_statements),
               left_join: cfes in assoc(f, :case_file_event_statements),
               left_join: o in assoc(f, :case_file_owners),
               left_join: a in assoc(o, :addresses),
               preload: [attorney: att,
                         correspondent: c,
                         case_file_statements: cfs,
                         case_file_event_statements: cfes,
                         case_file_owners: {o, addresses: a}],
               select: map(f, [:id, :abandonment_date, :filing_date, :registration_date, :registration_number,
                               :renewal_date, :serial_number, :status_date, :trademark,
                               attorney: [:id, :name],
                               correspondent: [:id, :address_1, :address_2, :address_3, :address_4, :address_5],
                               case_file_owners: [:id, :dba, :nationality_country, :nationality_state, :party_name,
                                                  addresses: [:id, :address_1, :address_2, :city, :state, :postcode, :country]],
                               case_file_statements: [:id, :type_code, :description],
                               case_file_event_statements: [:id, :code, :type, :description, :date]]))
  end

  def by_owner(params) do
    term = params[:owner]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    Repo.all from(owner in CaseFileOwner,
               where: ilike(owner.party_name, ^query),
               left_join: a in assoc(owner, :addresses),
               left_join: f in assoc(owner, :case_files),
               left_join: att in assoc(f, :attorney),
               left_join: c in assoc(f, :correspondent),
               preload: [addresses: a,
                         case_files: {f, attorney: att, correspondent: c}],
               select: map(owner, [:id, :dba, :nationality_country, :nationality_state, :party_name,
                                   addresses:
                                     [:id, :address_1, :address_2, :city, :state, :postcode, :country],
                                   case_files:
                                     [:id, :abandonment_date, :filing_date, :registration_date, :registration_number,
                                      :renewal_date, :serial_number, :status_date, :trademark,
                                      attorney: [:id, :name],
                                      correspondent: [:id, :address_1, :address_2, :address_3, :address_4, :address_5]]]))
  end

  def by_correspondent(params) do
    term = params[:correspondent]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    Repo.all from(c in Correspondent,
               where: ilike(c.address_1, ^query),
               preload: [:case_files,
                         :attorneys,
                         :case_file_owners,
                         :addresses],
               select: map(c, [:id, :address_1, :address_2, :address_3, :address_4, :address_5,
                           case_files:
                             [:id, :abandonment_date, :filing_date, :registration_date, :registration_number,
                              :renewal_date, :serial_number, :status_date, :trademark,
                              attorney: [:id, :name],
                              case_file_owners: [:id, :dba, :nationality_country, :nationality_state, :party_name,
                                                 addresses: [:id, :address_1, :address_2, :city, :state, :postcode, :country]]]]))
  end

  def linked_trademarks(params) do
    term = params[:trademark]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    from(f in CaseFile,
      where: ilike(f.trademark, ^query),
      preload: [:linked],
      select: map(f, [:id, :trademark, linked: [:id, :trademark]]))
    |> Repo.all
    |> Enum.map(&drop_self/1)
  end

  def linked_owners(params) do
    term = params[:owner]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    from(o in CaseFileOwner,
      where: ilike(o.party_name, ^query),
      preload: [:linked],
      select: map(o, [:id, :dba, :nationality_country, :nationality_state, :party_name,
                      linked: [:id, :dba, :nationality_country, :nationality_state, :party_name]]))
    |> Repo.all
    # |> Enum.map(&drop_self/1)
  end

  defp drop_self(%{id: id, trademark: trademark, linked: list}) do
    %{id: id, trademark: trademark,
      linked: List.delete(list, %{id: id, trademark: trademark})}
  end

  defp drop_self(%{id: id, dba: dba, nationality_country: nationality_country,
                   nationality_state: nationality_state, party_name: party_name,
                   linked: list}) do
    %{id: id, dba: dba, nationality_country: nationality_country,
      nationality_state: nationality_state, party_name: party_name,
      linked: List.delete(list, %{id: id, dba: dba, nationality_country: nationality_country,
                                  nationality_state: nationality_state, party_name: party_name})}
  end
end