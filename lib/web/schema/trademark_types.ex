defmodule Trademarks.Web.Schema.TrademarkTypes do
  use Absinthe.Schema.Notation

  alias Trademarks.Web.{
    AddressResolver,
    AttorneyResolver,
    CaseFileResolver,
    CorrespondentResolver,
    EventStatementResolver,
    OwnerResolver,
    StatementResolver,
    TrademarkResolver
  }

  object :address do
    field :address_1, non_null(:string)
    field :address_2, :string
    field :city, :string
    field :state, :string
    field :postcode, :string
    field :country, :string
  end

  object :attorney do
    field :name, non_null(:string)
  end

  object :case_file do
    field :serial_number, non_null(:string)
    field :abandonment_date, :integer
    field :filing_date, :integer
    field :registration_date, :integer
    field :registration_number, :string
    field :renewal_date, :integer
    field :status_date, :integer
    field :attorney, non_null(:attorney) do
      resolve &AttorneyResolver.case_file_attorney/3
    end
    field :correspondent, non_null(:correspondent) do
      resolve &CorrespondentResolver.case_file_correspondent/3
    end
    field :owners, non_null(list_of(non_null(:owner))) do
      resolve &OwnerResolver.case_file_owner/3
    end
    field :event_statements, non_null(list_of(non_null(:event_statement))) do
      resolve &EventStatementResolver.case_file_event_statement/3
    end
    field :statements, non_null(list_of(non_null(:statement))) do
      resolve &StatementResolver.case_file_statement/3
    end
  end

  object :correspondent do
    field :address_1, non_null(:string)
    field :address_2, :string
    field :address_3, :string
    field :address_4, :string
    field :address_5, :string
  end

  object :event_statement do
    field :description, non_null(:string)
    field :date, :integer
  end

  object :owner do
    field :name, non_null(:string)
    field :dba, :string
    field :nationality_state, :string
    field :nationality_country, :string
    field :address, non_null(:address) do
      resolve &AddressResolver.owner_address/3
    end
  end

  object :statement do
    field :description, non_null(:string)
  end

  object :trademark do
    field :name, non_null(:string)
  end

end