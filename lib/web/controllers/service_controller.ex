defmodule Trademarks.Web.ServiceController do
  @moduledoc """
  Trademarks service calls.
  """

  use Trademarks.Web, :controller

  alias Trademarks.Models.Nodes.{
    Address,
    Attorney,
    CaseFile,
    Correspondent,
    EventStatement,
    Owner,
    Statement,
    Trademark
  }

  @doc """
  Get all trademarks available to the specified request context.

  ## Parameters

    - JSON: specifying a context data to query for matching factors to determine trademarks.

  ## Renders
    - 200 and each matching trademark's details: if one or more matching trademarks where found.
    - 404: if no matching trademarks were found.
  """
  def available_trademarks(conn, %{} = request_data, options \\ @filter_options) do
    update_request_with_oauth(conn, request_data)
    |> get_trademarks(options)
    |> Enum.map(fn o -> Map.from_struct(o) end)
    |> render_result(conn)
  end

  @doc """
  Get the details for the specified set of trademark ids.

  ## Parameters

    - JSON: specifying a context data to query for matching factors to determine trademarks.

  ## Renders
    - 200 and each matching trademark's details: if one or more matching trademarks where found.
    - 404: if no matching trademarks were found.
  """
  def trademark_details(conn, %{} = request_data) do
    request_data
    |> RequestData.find_all("/trademarks")
    |> Enum.map(fn name -> %Trademark{name: name} end)
    |> Trademark.find()
    |> render_result(conn)
  end

  @doc """
  Validate Trademarks and return their details in terms of the request context.  Answers the question: "Are these trademarks
  valid for this contextual user data?"

  ## Parameters

    - JSON: specifying a block of request data to query for matching factors to determine available trademarks.

  ## Renders
    - 200 and trademark details: if the trademark is valid for the given request data.
    - 404: if no matching trademarks were found or the given trademark is not in the set of matching trademarks for the given data.
  """
  def validate_trademarks(conn, %{} = request_data, options \\ []) do
    trademarks = RequestData.find_all(request_data, "/trademarks")

    update_request_with_oauth(conn, request_data)
    |> get_trademarks(options)
    |> Enum.filter(fn t -> Enum.member?(trademarks, t.name) end)
    |> render_result(conn)
  end

  # PRIVATE

  defp get_trademarks(request_data, options \\ []) do
    request_data
    |> Trademark.matching_trademarks(options)
  end

  defp validate(request_data, Trademarks) do
  end

  defp render_result(result, conn) when is_nil(result) or result == [] do
    conn
    |> put_status(404)
    |> render(Trademarks.Web.ErrorView, "404.json")
  end

  defp render_result(result, conn) when is_list(result) do
    result = Enum.map(result, &SalesCopy.attach(&1))
    results = Enum.map(result, &Product.attach(&1))
    render(conn, "index.json", trademarks: results, state: conn.body_params)
  end

  defp render_result(result, conn) do
    result = SalesCopy.attach(result)
    results = Product.attach(result)
    render(conn, "show.json", trademark: results, state: conn.body_params)
  end

  defp request_user(conn) do
  end

  defp update_request_with_oauth(conn, %{} = request_data) do
    case Enum.into(conn.req_headers, %{}) do
      %{"authorization" => oauth1} ->
        Map.merge(request_data, %{"authorization" => oauth1})

      %{"x-jwt-authorization" => oauth2} ->
        Map.merge(request_data, %{"x-jwt-authorization" => oauth2})

      _ ->
        # debug(conn.req_headers, "This header did not match anything")
        request_data
    end
  end
end