defmodule TrademarksWeb.AttorneyView do
  use TrademarksWeb, :view
  alias TrademarksWeb.AttorneyView

  def render("index.json", %{attorneys: attorneys}) do
    %{data: render_many(attorneys, AttorneyView, "attorney.json")}
  end

  def render("show.json", %{attorney: attorney}) do
    %{data: render_one(attorney, AttorneyView, "attorney.json")}
  end

  def render("attorney.json", %{attorney: attorney}) do
    %{id: attorney.id, name: attorney.name}
  end

  def render("search.json", %{entries: entries}) do
    %{data: entries}
  end
end
