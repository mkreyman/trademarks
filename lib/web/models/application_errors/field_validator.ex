defmodule ApplicationErrors.FieldValidator do
  @doc """
  """
  def validate_presence(value) when is_binary(value) do
    !is_nil(value) && value != ""
  end

  def validate_presence(value) do
    !is_nil(value)
  end

  def value_missing(value) do
    !validate_presence(value)
  end
end
