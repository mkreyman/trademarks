defmodule Util.PipeDebug do
  @moduledoc """
  Support the injection of inspect capabilities in an elixir pipe |> pipestream.
  """

  defmacro __using__(_opts) do
    quote do
      import Util.PipeDebug, warn: false
    end
  end

  @shut_up Application.get_env(:logger, :shut_up_pipe_debug, true)

  require Logger

  @doc """
  Writes an inspection dump of the given object to standard output, optionally preceded by a message.  Used to place
  inspections in the midst of a chain of piped calls.

  ## Parameters

    - val: Value to be inspected.
    - message: optional message to precede the value inspection.

  ## Returns

    - The value dumped in the inspection, unchanged.

  ## Examples

    iex> %{ jazz: "Art", messenger: "Blakey" } |> Map.values |> Util.PipeDebug("Jazz Message") |> Enum.reverse

  """
  @spec debug(any(), String.t()) :: any()
  def debug(val, message \\ nil, opts \\ []) do
    unless @shut_up do
      condition = opts[:condition] || fn _val -> true end
      condition.(val) && dbg(Mix.env(), val, message)
    end

    val
  end

  defp dbg(:prod, _val, _message) do
  end

  defp dbg(:dev, val, message) when is_nil(message) do
    Logger.debug(inspect(val, pretty: true))
  end

  defp dbg(:dev, val, message) do
    Logger.debug(fn -> "#{message}: #{inspect(val, pretty: true)}" end)
  end

  defp dbg(:test, val, message) when is_nil(message) do
    IO.inspect(val, pretty: true)
  end

  defp dbg(:test, val, message) do
    IO.puts("#{message}: #{inspect(val, pretty: true)}")
  end
end
