defmodule Util.InterfaceBase do
  use Util.PipeDebug

  import Util.StructUtils

  @moduledoc """
  Macros and functions to support interface wrappers over Node and Link objects.  Interfaces allow different operations
  to be performed on the same underlying objects.
  """

  defmacro __using__(_opts) do
    quote do
      import Util.InterfaceBase

      def struct_to_name do
        __MODULE__
        |> Module.split()
        |> List.last()
      end

      def new(options) do
        empty_instance()
        |> merge_options(options)
      end

      def create(module, options) do
        options
        |> new()
        |> module.create()
      end
    end
  end

  @doc """
  Merges the given options into the given Map.  Useful for adding values beyond the initial defaults to a struct.

  ## Parameters

    - map: The (immutable) Map or struct to add the key/value pairs to.
    - options: Keywords as options (foo: "bar", narf: "plotz") for assignment to the struct.  Note that these properties
      must be valid members defined as part of the defstruct for the specified Map if the Map is a struct.

  ## Returns

    - A modified copy of Map with the options assigned as keys/values.
  """
  @spec merge_options(map(), keyword()) :: map()
  def merge_options(map, [option | options]) do
    {k, v} = option
    merge_options(Map.put(map, k, v), options)
  end

  @doc false
  def merge_options(map, []) do
    map
  end

  @doc false
  def merge_options(map) do
    map
  end

  @doc """
  Given a structure, attempt to determine its module from a module member, and if unavailable, from its __struct__.

  ## Parameters

    - structure: a structure instance to interogate for the defining module to instantiate.

  ## Returns

    - an instance of the module that defines the structure or acts as an interface for the structure.
  """
  @spec interface_module(map()) :: atom()
  def interface_module(structure) do
    (Map.has_key?(structure, :module) && String.to_atom(structure.module)) ||
      module_for(structure)
  end
end
