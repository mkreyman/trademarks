defmodule TrademarksWeb.Router do
  use TrademarksWeb, :router

  pipeline :api do
    # plug(:accepts, ["json"])
    # json-api is the only one we support
    plug(:accepts, ["json-api"])
    plug(JaSerializer.ContentTypeNegotiation)
    plug(JaSerializer.Deserializer)
    plug(TrademarksWeb.Plugs.RequireUUID, Ecto.UUID.generate())
  end

  scope "/api", TrademarksWeb, as: :api do
    pipe_through(:api)

    scope "/v1", V1, as: :v1 do
      get("/search", SearchController, :search)
      resources("/trademarks", TrademarkController, only: [:index, :show])
      resources("/attorneys", AttorneyController, only: [:index, :show])
      resources("/correspondents", CorrespondentController, only: [:index, :show])
      resources("/case_files", CaseFileController, only: [:index, :show])
      resources("/case_file_owners", CaseFileOwnerController, only: [:index, :show])
    end
  end
end
