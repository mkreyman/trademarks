defmodule Trademarks.Search do
  import Ecto.Query

  alias Trademarks.{
    Attorney,
    Trademark,
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
    from(att in Attorney,
      where: ilike(att.name, ^query),
      left_join: f in assoc(att, :case_files),
      left_join: t in assoc(f, :trademark),
      left_join: c in assoc(f, :correspondent),
      left_join: o in assoc(f, :case_file_owners),
      left_join: a in assoc(o, :addresses),
      preload: [case_files: {f, trademark: t, correspondent: c,
                                case_file_owners: {o, addresses: a}}],
      select: map(att, [:id, :name,
                        case_files:
                          [:id, :abandonment_date, :filing_date, :registration_date,
                           :registration_number, :renewal_date, :serial_number, :status_date,
                           trademark: [:id, :name],
                           correspondent: [:id, :address_1, :address_2,
                                           :address_3, :address_4, :address_5],
                           case_file_owners: [:id, :dba, :nationality_country,
                                              :nationality_state, :party_name,
                                              addresses: [:id, :address_1, :address_2, :city,
                                                          :state, :postcode, :country]]]]))
    |> Repo.all
  end

  def by_trademark(params) do
    term = params[:trademark]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    from(t in Trademark,
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
                                   correspondent: [:id, :address_1, :address_2,
                                                   :address_3, :address_4, :address_5],
                                   case_file_statements: [:id, :type_code, :description],
                                   case_file_event_statements: [:id, :code, :type, :description, :date]],
                      case_file_owners: [:id, :dba, :nationality_country, :nationality_state, :party_name,
                                         addresses: [:id, :address_1, :address_2, :city,
                                                     :state, :postcode, :country]]]))
    |> Repo.all
  end

  def by_owner(params) do
    term = params[:owner]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    from(o in CaseFileOwner,
      where: ilike(o.party_name, ^query),
      left_join: t in assoc(o, :trademarks),
      left_join: a in assoc(o, :addresses),
      left_join: f in assoc(o, :case_files),
      left_join: att in assoc(f, :attorney),
      left_join: c in assoc(f, :correspondent),
      preload: [trademarks: t,
                addresses: a,
                case_files: {f, attorney: att, correspondent: c}],
      select: map(o, [:id, :dba, :nationality_country, :nationality_state, :party_name,
                      trademarks: [:id, :name],
                      addresses: [:id, :address_1, :address_2, :city,
                                  :state, :postcode, :country],
                      case_files: [:id, :abandonment_date, :filing_date,
                                   :registration_date, :registration_number,
                                   :renewal_date, :serial_number, :status_date,
                                   attorney: [:id, :name],
                                   correspondent: [:id, :address_1, :address_2,
                                                   :address_3, :address_4, :address_5]]]))
    |> Repo.all
  end

  def by_correspondent(params) do
    term = params[:correspondent]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    from(c in Correspondent,
      where: ilike(c.address_1, ^query),
      left_join: f in assoc(c, :case_files),
      left_join: att in assoc(f, :attorney),
      left_join: t in assoc(f, :trademark),
      left_join: o in assoc(f, :case_file_owners),
      left_join: a in assoc(o, :addresses),
      preload: [case_files: {f, attorney: att,
                                trademark: t,
                                case_file_owners: {o, addresses: a}}],
      select: map(c, [:id, :address_1, :address_2,
                      :address_3, :address_4, :address_5,
                      case_files: [:id, :abandonment_date, :filing_date,
                                   :registration_date, :registration_number,
                                   :renewal_date, :serial_number, :status_date,
                                   attorney: [:id, :name],
                                   trademark: [:id, :name],
                                   case_file_owners: [:id, :dba, :nationality_country,
                                                      :nationality_state, :party_name,
                                                      addresses: [:id, :address_1,
                                                                  :address_2, :city,
                                                                  :state, :postcode, :country]]]]))
    |> Repo.all
  end

  def linked_trademarks(params) do
    term = params[:trademark]
    query =
      case params[:exact] do
        true -> "#{term}"
        _    -> "%#{term}%"
      end
    from(t in Trademark,
      where: ilike(t.name, ^query),
      join: o in assoc(t, :case_file_owners),
      join: t2 in assoc(o, :trademarks),
      preload: [case_file_owners: {o, trademarks: t2}],
      select: map(t, [:id, :name,
                      case_file_owners: [:id, :party_name,
                                         trademarks: [:id, :name]]]))
    |> Repo.all
    |> Enum.map(&drop_self/1)
  end

  defp drop_self(%{id: id, name: trademark,
                   case_file_owners: [%{id: owner_id,
                                        party_name: owner_name,
                                        trademarks: list}]}) do
    %{id: id, name: trademark,
      linked: [%{owner_id: owner_id,
                 owner_name: owner_name,
                 trademarks: List.delete(list, %{id: id, name: trademark})}]}
  end
end