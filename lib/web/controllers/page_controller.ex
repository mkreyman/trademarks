defmodule Trademarks.Web.PageController do
  use Trademarks.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end