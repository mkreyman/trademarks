defmodule Trademarks.Web.Router do
  use Trademarks.Web, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", Trademarks.Web do
    pipe_through(:api)

    post("/trademarks", ServiceController, :available_trademarks)
    get("/trademarks", ServiceController, :available_trademarks)
    post("/trademarks/details", ServiceController, :trademark_details)
  end
end
