defmodule Trademarks.Web.StatementResolver do
  alias Trademarks.Models.Nodes.Statement

  def case_file_statement(case_file, _args, _info) do
    statement = Statement.find_by_case_file(case_file)
    {:ok, statement}
  end
end