defmodule TrademarksWeb.Plugs.RequireUUID do
  def init(random), do: random

  def call(%Plug.Conn{params: %{"id" => id}} = conn, random) do
    case Ecto.UUID.cast(id) do
      {:ok, _id} -> conn
      :error -> Map.put(conn, :params, %{"id" => random})
    end
  end

  def call(%Plug.Conn{params: %{}} = conn, _random), do: conn
end
