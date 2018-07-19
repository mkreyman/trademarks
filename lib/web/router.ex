defmodule TrademarksWeb.Router do
  use TrademarksWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", TrademarksWeb do
    pipe_through(:api)
  end
end
