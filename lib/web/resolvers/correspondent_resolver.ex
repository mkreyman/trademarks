defmodule Trademarks.Web.CorrespondentResolver do
  alias Trademarks.Models.Nodes.Correspondent

  def case_file_correspondent(case_file, _args, _info) do
    correspondent = Correspondent.find_by_case_file(case_file)
    {:ok, correspondent}
  end
end