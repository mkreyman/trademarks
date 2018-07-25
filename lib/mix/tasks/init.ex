defmodule Mix.Tasks.Neo4j.Init do
  use Mix.Task

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:trademarks)
    initialize()
  end

  defp initialize() do
    """
    CREATE CONSTRAINT ON (tm:Trademark) ASSERT tm.name IS UNIQUE;
    CREATE CONSTRAINT ON (a:Attorney) ASSERT a.name IS UNIQUE;
    CREATE CONSTRAINT ON (c:Correspondent) ASSERT c.hash IS UNIQUE;
    CREATE CONSTRAINT ON (cf:CaseFile) ASSERT cf.serial_number IS UNIQUE;
    CREATE CONSTRAINT ON (o:Owner) ASSERT o.name IS UNIQUE;
    CREATE CONSTRAINT ON (s:Statement) ASSERT s.hash IS UNIQUE;
    CREATE CONSTRAINT ON (es:EventStatement) ASSERT es.hash IS UNIQUE;
    CREATE CONSTRAINT ON (addr:Address) ASSERT addr.hash IS UNIQUE;
    """
    |> String.split(";")
    |> Enum.map(&Neo4j.Core.exec_raw(&1))
  end
end
