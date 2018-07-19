defmodule Neo4j.Tasks.Init do
  def call() do
    initialize()
    Mix.Task.reenable(:run)
  end

  defp initialize() do
    """
    CREATE CONSTRAINT ON (tm:Trademark) ASSERT tm.name IS UNIQUE;
    CREATE CONSTRAINT ON (a:Attorney) ASSERT a.name IS UNIQUE;
    CREATE CONSTRAINT ON (c:Correspondent) ASSERT c.address_1 IS UNIQUE;
    CREATE CONSTRAINT ON (cf:CaseFile) ASSERT cf.serial_number IS UNIQUE;
    CREATE CONSTRAINT ON (o:Owner) ASSERT o.name IS UNIQUE;
    CREATE CONSTRAINT ON (s:Statement) ASSERT s.hash IS UNIQUE;
    CREATE CONSTRAINT ON (es:EventStatement) ASSERT es.hash IS UNIQUE;
    CREATE CONSTRAINT ON (addr:Address) ASSERT addr.hash IS UNIQUE;
    """
    |> Neo4j.Core.exec_raw()
  end
end

Neo4j.Tasks.Init.call()
