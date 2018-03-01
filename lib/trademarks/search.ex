defmodule Trademarks.Search do
  import Ecto.Query

  alias Trademarks.{
    Attorney,
    Trademark,
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
               left_join: t in assoc(f, :trademark),
               left_join: c in assoc(f, :correspondent),
               left_join: o in assoc(f, :case_file_owners),
               left_join: a in assoc(o, :addresses),
               preload: [case_files: {f,
                         trademark: t,
                         correspondent: c,
                         case_file_owners: {o, addresses: a}}],
               select: map(attorney, [:id, :name,
                           case_files: [:id, :abandonment_date, :filing_date, :registration_date, :registration_number,
                             :renewal_date, :serial_number, :status_date,
                             trademark: [:id, :name],
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
    Repo.all from(t in Trademark,
               where: ilike(t.name, ^query),
               left_join: f in assoc(t, :case_files),
               left_join: att in assoc(f, :attorney),
               left_join: c in assoc(f, :correspondent),
               left_join: cfs in assoc(f, :case_file_statements),
               left_join: cfes in assoc(f, :case_file_event_statements),
               left_join: o in assoc(t, :case_file_owners),
               left_join: a in assoc(o, :addresses),
               preload: [case_files: {f,
                         attorney: att,
                         correspondent: c,
                         case_file_statements: cfs,
                         case_file_event_statements: cfes},
                         case_file_owners: {o, addresses: a}],
               select: map(t, [:id, :name,
                               case_files: [:id, :abandonment_date, :filing_date,
                                            :registration_date, :registration_number,
                                            :renewal_date, :serial_number, :status_date,
                                            attorney: [:id, :name],
                                            correspondent: [:id, :address_1, :address_2, :address_3, :address_4, :address_5],
                                            case_file_statements: [:id, :type_code, :description],
                                            case_file_event_statements: [:id, :code, :type, :description, :date]],
                               case_file_owners: [:id, :dba, :nationality_country, :nationality_state, :party_name,
                                                  addresses: [:id, :address_1, :address_2, :city, :state, :postcode, :country]]]))
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
               left_join: f in assoc(c, :case_files),
               left_join: att in assoc(f, :attorney),
               left_join: o in assoc(f, :case_file_owners),
               left_join: a in assoc(o, :addresses),
               preload: [case_files: {f, attorney: att, case_file_owners: {o, addresses: a}}],
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
      join: o in assoc(f, :case_file_owners),
      join: f2 in assoc(o, :case_files),
      preload: [case_file_owners: {o, case_files: f2}],
      select: map(f, [:id, :trademark, case_file_owners: [:id, :party_name, case_files: [:id, :trademark]]]))
    |> Repo.all
    |> Enum.map(&drop_self/1)
  end

  defp drop_self(%{id: id, trademark: trademark, case_file_owners: [%{id: owner_id, party_name: owner_name, case_files: list}]}) do
    %{id: id, trademark: trademark,
      linked: [%{owner_id: owner_id, owner_name: owner_name, case_files: List.delete(list, %{id: id, trademark: trademark})}]}
  end
end