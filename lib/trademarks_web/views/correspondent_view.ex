defmodule TrademarksWeb.CorrespondentView do
  use TrademarksWeb, :view
  alias TrademarksWeb.CorrespondentView

  def render("index.json", %{correspondents: correspondents}) do
    %{data: render_many(correspondents, CorrespondentView, "correspondent.json")}
  end

  def render("show.json", %{correspondent: correspondent}) do
    %{data: render_one(correspondent, CorrespondentView, "correspondent.json")}
  end

  def render("correspondent.json", %{correspondent: correspondent}) do
    %{
      id: correspondent.id,
      address_1: correspondent.address_1,
      address_2: correspondent.address_2,
      address_3: correspondent.address_3,
      address_4: correspondent.address_4,
      address_5: correspondent.address_5
    }
  end
end
