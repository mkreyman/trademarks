defmodule TrademarksWeb.Router do
  use TrademarksWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", TrademarksWeb do
    pipe_through(:api)

    get "/trademarks/search", TrademarkController, :search

    resources "/trademarks", TrademarkController, only: [:index, :show]
    resources "/attorneys", AttorneyController, only: [:index, :show]
    resources "/correspondents", CorrespondentController, only: [:index, :show]
    resources "/case_files", CaseFileController, only: [:index, :show]
    resources "/case_file_owners", CaseFileOwnerController, only: [:index, :show]
  end
end
