defmodule Trademarks.Search do
  import Ecto.Query

  alias Trademarks.{
    Attorney,
    Trademark,
    Correspondent,
    CaseFileOwner,
    Repo
  }

  def by_attorney(name) do
    from(
      att in Attorney,
      where: ilike(att.name, ^"%#{name}%"),
      left_join: f in assoc(att, :case_files),
      left_join: t in assoc(f, :trademark),
      left_join: c in assoc(f, :correspondent),
      left_join: o in assoc(f, :case_file_owners),
      preload: [
        case_files: {f, trademark: t, correspondent: c, case_file_owners: o}
      ],
      select:
        map(att, [
          :id,
          :name,
          case_files: [
            :id,
            :abandonment_date,
            :filing_date,
            :registration_date,
            :registration_number,
            :renewal_date,
            :serial_number,
            :status_date,
            trademark: [:id, :name],
            correspondent: [:id, :address_1, :address_2, :address_3, :address_4, :address_5],
            case_file_owners: [
              :id,
              :dba,
              :nationality_country,
              :nationality_state,
              :name,
              :address_1,
              :address_2,
              :city,
              :state,
              :postcode,
              :country
            ]
          ]
        ])
    )
    |> Repo.all()
  end

  def by_trademark(name) do
    from(
      t in Trademark,
      where: ilike(t.name, ^"%#{name}%"),
      left_join: f in assoc(t, :case_files),
      left_join: att in assoc(f, :attorney),
      left_join: c in assoc(f, :correspondent),
      left_join: cfs in assoc(f, :case_file_statements),
      left_join: cfes in assoc(f, :case_file_event_statements),
      left_join: o in assoc(t, :case_file_owners),
      preload: [
        case_files:
          {f,
           attorney: att,
           correspondent: c,
           case_file_statements: cfs,
           case_file_event_statements: cfes},
        case_file_owners: o
      ],
      select:
        map(t, [
          :id,
          :name,
          case_files: [
            :id,
            :abandonment_date,
            :filing_date,
            :registration_date,
            :registration_number,
            :renewal_date,
            :serial_number,
            :status_date,
            attorney: [:id, :name],
            correspondent: [:id, :address_1, :address_2, :address_3, :address_4, :address_5],
            case_file_statements: [:id, :type_code, :description],
            case_file_event_statements: [:id, :code, :event_type, :description, :date]
          ],
          case_file_owners: [
            :id,
            :dba,
            :nationality_country,
            :nationality_state,
            :name,
            :address_1,
            :address_2,
            :city,
            :state,
            :postcode,
            :country
          ]
        ])
    )
    |> Repo.all()
  end

  def by_owner(name) do
    from(
      o in CaseFileOwner,
      where: ilike(o.name, ^"%#{name}%"),
      left_join: t in assoc(o, :trademarks),
      left_join: f in assoc(o, :case_files),
      left_join: att in assoc(f, :attorney),
      left_join: c in assoc(f, :correspondent),
      preload: [trademarks: t, case_files: {f, attorney: att, correspondent: c}],
      select:
        map(o, [
          :id,
          :dba,
          :nationality_country,
          :nationality_state,
          :name,
          :address_1,
          :address_2,
          :city,
          :state,
          :postcode,
          :country,
          trademarks: [:id, :name],
          case_files: [
            :id,
            :abandonment_date,
            :filing_date,
            :registration_date,
            :registration_number,
            :renewal_date,
            :serial_number,
            :status_date,
            attorney: [:id, :name],
            correspondent: [:id, :address_1, :address_2, :address_3, :address_4, :address_5]
          ]
        ])
    )
    |> Repo.all()
  end

  def by_correspondent(address_1) do
    from(
      c in Correspondent,
      where: ilike(c.address_1, ^"%#{address_1}%"),
      left_join: f in assoc(c, :case_files),
      left_join: att in assoc(f, :attorney),
      left_join: t in assoc(f, :trademark),
      left_join: o in assoc(f, :case_file_owners),
      preload: [case_files: {f, attorney: att, trademark: t, case_file_owners: o}],
      select:
        map(c, [
          :id,
          :address_1,
          :address_2,
          :address_3,
          :address_4,
          :address_5,
          case_files: [
            :id,
            :abandonment_date,
            :filing_date,
            :registration_date,
            :registration_number,
            :renewal_date,
            :serial_number,
            :status_date,
            attorney: [:id, :name],
            trademark: [:id, :name],
            case_file_owners: [
              :id,
              :dba,
              :nationality_country,
              :nationality_state,
              :name,
              :address_1,
              :address_2,
              :city,
              :state,
              :postcode,
              :country
            ]
          ]
        ])
    )
    |> Repo.all()
  end

  def linked_trademarks(name) do
    from(
      t in Trademark,
      where: ilike(t.name, ^"%#{name}%"),
      join: o in assoc(t, :case_file_owners),
      join: t2 in assoc(o, :trademarks),
      preload: [case_file_owners: {o, trademarks: t2}],
      select: map(t, [:id, :name, case_file_owners: [:id, :name, trademarks: [:id, :name]]])
    )
    |> Repo.all()
  end
end
