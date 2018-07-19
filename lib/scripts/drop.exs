defmodule Neo4j.Tasks.Drop do
  def call() do
    drop()
    Mix.Task.reenable(:run)
  end

  defp drop() do
    "MATCH (n) DETACH DELETE n"
    |> Neo4j.Core.exec_raw()
  end
end

Neo4j.Tasks.Drop.call()
