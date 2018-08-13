defmodule Trademarks.Web.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom
  import_types Trademarks.Web.Schema.TrademarkTypes

  alias Trademarks.Web.{
    AddressResolver,
    CaseFileResolver,
    OwnerResolver,
    TrademarkResolver
  }

  query do
    field :address, :address do
      arg :address_1, non_null(:string)

      resolve &AddressResolver.search_address/3
    end

    field :case_file, :case_file do
      arg :serial_number, non_null(:string)

      resolve &CaseFileResolver.search_case_file/3
    end

    field :trademark, :trademark do
      arg :name, non_null(:string)

      resolve &TrademarkResolver.search_trademark/3
    end

    field :trademarks, non_null(list_of(non_null(:trademark))) do
      resolve &TrademarkResolver.list_trademarks/3
    end

    field :owner, list_of(:owner) do
      arg :name, non_null(:string)

      resolve &OwnerResolver.search_owner/3
    end

    field :owners, non_null(list_of(non_null(:owner))) do
      resolve &OwnerResolver.list_owners/3
    end
  end
end