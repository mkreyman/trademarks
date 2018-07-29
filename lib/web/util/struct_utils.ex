defmodule Util.StructUtils do
  @moduledoc """
  Utilities for dealing with elixir structs:
  - conversion from a map to a struct, including changing string keys to atoms.
  - getting empty struct instances from existing ones.
  - getting the name of a struct (last part of dotted module name).
  """

  # import Util.PipeDebug

  defmacro __using__(_opts) do
    quote do
      import Util.StructUtils

      @doc """

      Convert the given map into an instance of the struct supported by the module that uses StructUtils.

      ## Parameters

        - map: The map to convert into a structure.

      ## Returns

        See the documentation for #{__MODULE__}.structify/2
      """
      def structify(map) do
        structify(map, empty_instance())
      end

      @doc """
      Gets the last portion of the module name for the structue defined in the using module.

      ## Parameters

        - None.

      ## Returns

        - The last portion of the dotted module name for the structure.
      """
      def struct_to_name() do
        __MODULE__
        |> Module.split()
        |> List.last()
      end

      def link_label() do
        struct_to_name()
        |> Macro.underscore()
        |> String.upcase()
      end

      @doc """
      Provide an empty instance of the struct supported by the module that uses StructUtils.

      ## Parameters

        None.

      ## Returns

        See the documentation for #{__MODULE__}.empty_instance/1
      """
      def empty_instance() do
        raise "empty_instance() not implemented!"
      end

      # https://medium.com/@kay.sackey/create-a-struct-from-a-map-within-elixir-78bf592b5d3b
      def struct_from_map(map) do
        struct = __MODULE__.__struct__()

        keys =
          Map.keys(struct)
          |> Enum.filter(fn x -> x != :__struct__ end)

        processed_map =
          for key <- keys, into: %{} do
            value = Map.get(map, key) || Map.get(map, to_string(key))
            {key, value}
          end

        Map.merge(struct, processed_map)
      end

      defoverridable structify: 1
      defoverridable empty_instance: 0
      defoverridable struct_to_name: 0
    end
  end

  @doc """
  Create an "empty" instance of the given structure.

  ## Parameters

    - structure: The structure (node or link) to use as a template to create the empty instance.

  ## Returns

    - a struct of the same type as that given, but with default (empty) values.
  """
  def empty_instance(structure) do
    Map.fetch!(structure, :__struct__).__struct__
  end

  @doc """
  Make an instance of a struct from a module spec.
  """
  def make_struct(element) do
    %{properties: %{"module" => module_name}} = element
    String.to_atom(module_name).structify(element)
  end

  @doc """
  Gets the last portion of the module name that contains the given structure.

  ## Parameters

    - structure: The structure whose "short name" is to be extracted.

  ## Returns

    - The last portion of the dotted module name for the structure.
  """
  def struct_to_name(structure) do
    structure.__struct__
    |> Module.split()
    |> List.last()
  end

  @doc """
  Convert the given map into the specified structure, including turning binary string keys into atoms.

  ## Parameters

    - map: The map to turn into the given structure.
    - structure: An instance of the type of structure to convert the map to.

  ## Returns

    - The structure populated with the values from the map when the map is a non-nil Map instance.
    - Nil if the map is nil.
    - The "map" object itself if it is a non-Map instance object, like a list.  Only maps can be structified.
  """
  def structify(map, _structure) when is_nil(map) do
    nil
  end

  def structify(map, structure) when is_map(map) do
    structure
    |> empty_instance
    |> Map.merge(
      map.properties
      |> Map.new(fn {k, v} -> {(is_binary(k) && String.to_atom(to_string(k))) || k, v} end)
    )
  end

  def structify(map, _structure) do
    map
  end

  @doc """
  Given a struct object, determine the Module associated with it.

  ## Parameters

    - structure: A struct instance to query for the module.

  ## Returns

    - The module that defined the structure.
  """
  def module_for(structure) do
    structure.__struct__
  end
end
