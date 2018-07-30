defmodule Trademarks.Web.Search do
  import Util.PipeDebug
  import Util.StructUtils
  import Neo4j.Core, only: [exec_raw: 1]

  require Logger

  alias Trademarks.Models.Nodes.{
    Address,
    Attorney,
    CaseFile,
    Correspondent,
    EventStatement,
    Owner,
    Statement,
    Trademark
  }

  def by_attorney(params) do
    term =
      params[:attorney]
      |> String.upcase()

    """
      MATCH (att:Attorney)<-[:REPRESENTED_BY]-(o:Owner)
      WHERE att.name CONTAINS 'SALTER'
      WITH att, o
      MATCH (tm:Trademark)<-[:OWNS]-(o)-[:RESIDES_AT]->(a:Address)
      RETURN att, o, a, tm
    """
    |> exec_raw()
    |> debug("XXX after exec_raw() XXX: ")
    |> Enum.map(fn %{
                     "att" => attorney,
                     "o" => owner,
                     "a" => address,
                     "tm" => trademark
                   } ->
      {make_struct(attorney), make_struct(owner), make_struct(address), make_struct(trademark)}
    end)
    |> debug("XXX by_attorney() XXX:")
  end

  # #{term}
  # (s:Statement)-[:DESCRIBES]->(cf:CaseFile)-[:FILED_FOR]->(tm:Trademark)<-[:OWNS]-(o:Owner)-[:RESIDES_AT]->(a:Address)

  # # Search by TM name
  # MATCH (tm:Trademark)<-[:OWNS]-(o:Owner)-[:RESIDES_AT]->(a:Address)
  # WHERE tm.name CONTAINS 'TUSIMPLE'
  # RETURN tm, o, a

  # # Search by attorney name
  # MATCH (att:Attorney)<-[:REPRESENTED_BY]-(o:Owner)
  # WHERE att.name CONTAINS 'SALTER'
  # WITH att, o
  # MATCH (tm:Trademark)<-[:OWNS]-(o)-[:RESIDES_AT]->(a:Address)
  # RETURN att, o, a, tm

  # # Search by owner name
  # MATCH (a:Address)<-[:RESIDES_AT]-(o:Owner)-[:OWNS]->(tm:Trademark)
  # WHERE o.name CONTAINS 'TUSIMPLE'
  # RETURN o, a, tm

  # # Search for all owners of a TM
  # MATCH (tm:Trademark)<-[:FILED_FOR]-(cf:CaseFile)<-[:PARTY_TO]-(o:Owner)-[:RESIDES_AT]->(a:Address)
  # WHERE tm.name CONTAINS 'TUSIMPLE'
  # RETURN tm, cf, o, a



  # def by_attorney(params) do
  #   term = params[:attorney]

  #   query =
  #     case params[:exact] do
  #       true -> "#{term}"
  #       _ -> "%#{term}%"
  #     end

  #   from(
  #     att in Attorney,
  #     where: ilike(att.name, ^query),
  #     left_join: f in assoc(att, :case_files),
  #     left_join: t in assoc(f, :trademark),
  #     left_join: c in assoc(f, :correspondent),
  #     left_join: o in assoc(f, :case_file_owners),
  #     preload: [
  #       case_files: {f, trademark: t, correspondent: c, case_file_owners: o}
  #     ],
  #     select:
  #       map(att, [
  #         :id,
  #         :name,
  #         case_files: [
  #           :id,
  #           :abandonment_date,
  #           :filing_date,
  #           :registration_date,
  #           :registration_number,
  #           :renewal_date,
  #           :serial_number,
  #           :status_date,
  #           trademark: [:id, :name],
  #           correspondent: [:id, :address_1, :address_2, :address_3, :address_4, :address_5],
  #           case_file_owners: [
  #             :id,
  #             :dba,
  #             :nationality_country,
  #             :nationality_state,
  #             :party_name,
  #             :address_1,
  #             :address_2,
  #             :city,
  #             :state,
  #             :postcode,
  #             :country
  #           ]
  #         ]
  #       ])
  #   )
  #   |> Repo.all()
  # end

  # def by_trademark(params) do
  #   term = params[:trademark]

  #   query =
  #     case params[:exact] do
  #       true -> "#{term}"
  #       _ -> "%#{term}%"
  #     end

  #   from(
  #     t in Trademark,
  #     where: ilike(t.name, ^query),
  #     left_join: f in assoc(t, :case_files),
  #     left_join: att in assoc(f, :attorney),
  #     left_join: c in assoc(f, :correspondent),
  #     left_join: cfs in assoc(f, :case_file_statements),
  #     left_join: cfes in assoc(f, :case_file_event_statements),
  #     left_join: o in assoc(t, :case_file_owners),
  #     preload: [
  #       case_files:
  #         {f,
  #          attorney: att,
  #          correspondent: c,
  #          case_file_statements: cfs,
  #          case_file_event_statements: cfes},
  #       case_file_owners: o
  #     ],
  #     select:
  #       map(t, [
  #         :id,
  #         :name,
  #         case_files: [
  #           :id,
  #           :abandonment_date,
  #           :filing_date,
  #           :registration_date,
  #           :registration_number,
  #           :renewal_date,
  #           :serial_number,
  #           :status_date,
  #           attorney: [:id, :name],
  #           correspondent: [:id, :address_1, :address_2, :address_3, :address_4, :address_5],
  #           case_file_statements: [:id, :type_code, :description],
  #           case_file_event_statements: [:id, :code, :type, :description, :date]
  #         ],
  #         case_file_owners: [
  #           :id,
  #           :dba,
  #           :nationality_country,
  #           :nationality_state,
  #           :party_name,
  #           :address_1,
  #           :address_2,
  #           :city,
  #           :state,
  #           :postcode,
  #           :country
  #         ]
  #       ])
  #   )
  #   |> Repo.all()
  # end

  # def by_owner(params) do
  #   term = params[:owner]

  #   query =
  #     case params[:exact] do
  #       true -> "#{term}"
  #       _ -> "%#{term}%"
  #     end

  #   from(
  #     o in CaseFileOwner,
  #     where: ilike(o.party_name, ^query),
  #     left_join: t in assoc(o, :trademarks),
  #     left_join: f in assoc(o, :case_files),
  #     left_join: att in assoc(f, :attorney),
  #     left_join: c in assoc(f, :correspondent),
  #     preload: [trademarks: t, case_files: {f, attorney: att, correspondent: c}],
  #     select:
  #       map(o, [
  #         :id,
  #         :dba,
  #         :nationality_country,
  #         :nationality_state,
  #         :party_name,
  #         :address_1,
  #         :address_2,
  #         :city,
  #         :state,
  #         :postcode,
  #         :country,
  #         trademarks: [:id, :name],
  #         case_files: [
  #           :id,
  #           :abandonment_date,
  #           :filing_date,
  #           :registration_date,
  #           :registration_number,
  #           :renewal_date,
  #           :serial_number,
  #           :status_date,
  #           attorney: [:id, :name],
  #           correspondent: [:id, :address_1, :address_2, :address_3, :address_4, :address_5]
  #         ]
  #       ])
  #   )
  #   |> Repo.all()
  # end

  # def by_correspondent(params) do
  #   term = params[:correspondent]

  #   query =
  #     case params[:exact] do
  #       true -> "#{term}"
  #       _ -> "%#{term}%"
  #     end

  #   from(
  #     c in Correspondent,
  #     where: ilike(c.address_1, ^query),
  #     left_join: f in assoc(c, :case_files),
  #     left_join: att in assoc(f, :attorney),
  #     left_join: t in assoc(f, :trademark),
  #     left_join: o in assoc(f, :case_file_owners),
  #     preload: [case_files: {f, attorney: att, trademark: t, case_file_owners: o}],
  #     select:
  #       map(c, [
  #         :id,
  #         :address_1,
  #         :address_2,
  #         :address_3,
  #         :address_4,
  #         :address_5,
  #         case_files: [
  #           :id,
  #           :abandonment_date,
  #           :filing_date,
  #           :registration_date,
  #           :registration_number,
  #           :renewal_date,
  #           :serial_number,
  #           :status_date,
  #           attorney: [:id, :name],
  #           trademark: [:id, :name],
  #           case_file_owners: [
  #             :id,
  #             :dba,
  #             :nationality_country,
  #             :nationality_state,
  #             :party_name,
  #             :address_1,
  #             :address_2,
  #             :city,
  #             :state,
  #             :postcode,
  #             :country
  #           ]
  #         ]
  #       ])
  #   )
  #   |> Repo.all()
  # end

  # def linked_trademarks(params) do
  #   term = params[:trademark]

  #   query =
  #     case params[:exact] do
  #       true -> "#{term}"
  #       _ -> "%#{term}%"
  #     end

  #   from(
  #     t in Trademark,
  #     where: ilike(t.name, ^query),
  #     join: o in assoc(t, :case_file_owners),
  #     join: t2 in assoc(o, :trademarks),
  #     preload: [case_file_owners: {o, trademarks: t2}],
  #     select: map(t, [:id, :name, case_file_owners: [:id, :party_name, trademarks: [:id, :name]]])
  #   )
  #   |> Repo.all()
  #   |> Enum.map(&drop_self/1)
  # end

  # defp drop_self(%{
  #        id: id,
  #        name: trademark,
  #        case_file_owners: [%{id: owner_id, party_name: owner_name, trademarks: list}]
  #      }) do
  #   %{
  #     id: id,
  #     name: trademark,
  #     linked: [
  #       %{
  #         owner_id: owner_id,
  #         owner_name: owner_name,
  #         trademarks: List.delete(list, %{id: id, name: trademark})
  #       }
  #     ]
  #   }
  # end
end
