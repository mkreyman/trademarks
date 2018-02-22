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
               preload: [:case_files, :correspondents, :case_file_owners, :case_file_statements, :case_file_event_statements],
               select: map(attorney, [:id, :name,
                           case_files:
                             [:id, :serial_number, :registration_number, :filing_date,
                              :registration_date, :trademark, :renewal_date, :correspondent_id,
                              correspondent: [:id, :address_1, :address_2, :address_3, :address_4],
                              case_file_owners: [:id, :name, :address_1, :address_2, :city, :state, :postcode],
                              case_file_statements: [:id, :type_code, :description],
                              case_file_event_statements: [:id, :code, :type, :description, :date]]]))
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
               preload: [:attorney, :case_file_statements, :case_file_event_statements, :correspondent, :case_file_owners],
               select: map(f, [:id, :serial_number, :registration_number, :filing_date,
                               :registration_date, :trademark, :renewal_date, :attorney_id, :correspondent_id,
                               attorney: [:id, :name],
                               correspondent: [:id, :address_1, :address_2, :address_3, :address_4],
                               case_file_owners: [:id, :name, :address_1, :address_2, :city, :state, :postcode],
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
               where: ilike(owner.name, ^query),
               preload: [:case_files, :attorneys, :correspondents,:case_file_statements, :case_file_event_statements],
               select: map(owner, [:id, :name, :address_1, :address_2, :city, :state, :postcode,
                           case_files:
                             [:id, :serial_number, :registration_number, :filing_date,
                              :registration_date, :trademark, :renewal_date, :attorney_id, :correspondent_id,
                              attorney: [:id, :name],
                              correspondent: [:id, :address_1, :address_2, :address_3, :address_4],
                              case_file_statements: [:id, :type_code, :description],
                              case_file_event_statements: [:id, :code, :type, :description, :date]]]))
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
               preload: [:case_files, :attorneys, :case_file_owners, :case_file_statements, :case_file_event_statements],
               select: map(c, [:id, :address_1, :address_2, :address_3, :address_4,
                           case_files:
                             [:id, :serial_number, :registration_number, :filing_date,
                              :registration_date, :trademark, :renewal_date, :attorney_id, :correspondent_id,
                              attorney: [:id, :name],
                              case_file_owners: [:id, :name, :address_1, :address_2, :city, :state, :postcode],
                              case_file_statements: [:id, :type_code, :description],
                              case_file_event_statements: [:id, :code, :type, :description, :date]]]))
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
      where: ilike(o.name, ^query),
      preload: [:linked],
      select: map(o, [:id, :name, :address_1, :address_2, :city, :state, :postcode,
                      linked: [:id, :name, :address_1, :address_2, :city, :state, :postcode]]))
    |> Repo.all
    |> Enum.map(&drop_self/1)
  end

  defp drop_self(%{id: id, trademark: trademark,
                   linked: list}) do
    %{id: id, trademark: trademark,
      linked: List.delete(list, %{id: id, trademark: trademark})}
  end

  defp drop_self(%{id: id, name: name, address_1: address_1,
                   address_2: address_2, city: city,
                   state: state, postcode: postcode, linked: list}) do
    %{id: id, name: name, address_1: address_1,
      address_2: address_2, city: city,
      state: state, postcode: postcode,
      linked: List.delete(list, %{id: id, name: name,
                                  address_1: address_1, address_2: address_2,
                                  city: city, state: state, postcode: postcode})}
  end
end