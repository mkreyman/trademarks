defmodule Trademarks.Web.AttorneyResolver do
  alias Trademarks.Models.Nodes.Attorney

  def case_file_attorney(case_file, _args, _info) do
    attorney = Attorney.find_by_case_file(case_file)
    {:ok, attorney}
  end
end