defmodule TrademarksWeb.V1.SearchView do
  use TrademarksWeb, :view

  def render("search.json-api", %{results: results} = data) do
    %{
      links: links(data),
      jsonapi: %{version: "1.0"},
      data: results.entries
    }
  end

  defp links(%{
         results: results,
         query_params: query_params,
         request_path: request_path,
         base_url: base_url
       }) do
    JaSerializer.Builder.PaginationLinks.build(
      %{
        number: results.page_number,
        size: results.page_size,
        total: results.total_pages,
        base_url: base_url
      },
      %Plug.Conn{query_params: query_params, request_path: request_path}
    )
  end
end
