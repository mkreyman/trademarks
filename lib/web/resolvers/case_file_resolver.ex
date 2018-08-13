defmodule Trademarks.Web.CaseFileResolver do
  alias Trademarks.Models.Nodes.CaseFile

  def search_case_file(_root, %{serial_number: serial_number}, _info) do
    case_file = CaseFile.search(%CaseFile{serial_number: serial_number})
    {:ok, case_file}
  end
end