defmodule TrademarksWeb.Router do
  use TrademarksWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(TrademarksWeb.Plugs.RequireUUID, Ecto.UUID.generate())
  end

  scope "/api", TrademarksWeb do
    pipe_through(:api)

    get("/search", SearchController, :search)

    resources("/trademarks", TrademarkController, only: [:index, :show])
    resources("/attorneys", AttorneyController, only: [:index, :show])
    resources("/correspondents", CorrespondentController, only: [:index, :show])
    resources("/case_files", CaseFileController, only: [:index, :show])
    resources("/case_file_owners", CaseFileOwnerController, only: [:index, :show])
  end
end
