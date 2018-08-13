defmodule Trademarks.Web.LayoutView do
  use Trademarks.Web, :view

  # Make 204 No Content send body in response
  # Not to HTTP spec but for frontend projects
  def render("204.json", _assigns) do
    %{}
  end
end