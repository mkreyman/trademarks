defmodule Trademarks.Web.Schema do
  use Absinthe.Schema

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

  alias Trademarks.Web.{
    TrademarkResolver,
    AddressResolver,
    OwnerResolver
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
    field :address, non_null(:address)
  end

  object :statement do
    field :description, non_null(:string)
  end

  object :trademark do
    field :name, non_null(:string)
  end

  query do

    field :address, :address do
      arg :address_1, non_null(:string)

      resolve &AddressResolver.address/3
    end

    field :trademark, :trademark do
      arg :name, non_null(:string)

      resolve &TrademarkResolver.trademark/3
    end

    field :trademarks, non_null(list_of(non_null(:trademark))) do
      resolve &TrademarkResolver.trademarks/3
    end

    field :owner, list_of(:owner) do
      arg :name, non_null(:string)

      resolve &OwnerResolver.owner/3
    end

    field :owners, non_null(list_of(non_null(:owner))) do
      resolve &OwnerResolver.owners/3
    end

  end
end