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

  scope "/" do
    pipe_through(:api)

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: Trademarks.Web.Schema,
      interface: :simple,
      context: %{pubsub: Trademarks.Web.Endpoint}
  end
end
