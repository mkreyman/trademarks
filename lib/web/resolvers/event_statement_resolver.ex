defmodule Trademarks.Web.EventStatementResolver do
  alias Trademarks.Models.Nodes.EventStatement

  def case_file_event_statement(case_file, _args, _info) do
    event_statement = EventStatement.find_by_case_file(case_file)
    {:ok, event_statement}
  end
end