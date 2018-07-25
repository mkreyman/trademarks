defmodule Mix.Tasks.Neo4j.Drop do
  use Mix.Task

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:trademarks)
    drop()
  end

  defp drop() do
    "MATCH (n) DETACH DELETE n"
    |> Neo4j.Core.exec_raw()
  end
end
