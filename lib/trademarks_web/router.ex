defmodule TrademarksWeb.Router do
  use TrademarksWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", TrademarksWeb do
    pipe_through(:api)

    resources "/trademarks", TrademarkController, except: [:new, :edit]
    resources "/attorneys", AttorneyController, except: [:new, :edit]
    resources "/correspondents", CorrespondentController, except: [:new, :edit]
    resources "/case_files", CaseFileController, except: [:new, :edit]
    resources "/case_file_statements", CaseFileStatementController, except: [:new, :edit]
    resources "/case_file_event_statements", CaseFileEventStatementController, except: [:new, :edit]
    resources "/case_file_owners", CaseFileOwnerController, except: [:new, :edit]
    resources "/case_files_case_file_owners", CaseFilesCaseFileOwnerController, except: [:new, :edit]
    resources "/case_file_owners_trademarks", CaseFileOwnersTrademarkController, except: [:new, :edit]
  end
end
