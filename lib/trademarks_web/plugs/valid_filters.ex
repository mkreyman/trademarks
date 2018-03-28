defmodule TrademarksWeb.Plugs.ValidFilters do
  import Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{} = conn, params) do
    filters =
      Enum.filter(conn.params, fn {key, _value} ->
        Enum.member?(params, key)
      end)

    conn
    |> assign(:filters, filters)
  end

  def call(%Plug.Conn{params: %{}} = conn, _default), do: conn
end
