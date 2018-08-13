defmodule Trademarks.Web.Router do
  use Trademarks.Web, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api" do
    pipe_through(:api)

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: Trademarks.Web.Schema,
      interface: :simple,
      context: %{pubsub: Trademarks.Web.Endpoint}

    forward "/", Absinthe.Plug,
      schema: Trademarks.Web.Schema
  end

  scope "/", Trademarks.Web do
    pipe_through(:api)

    get("/", PageController, :index)
  end
end
