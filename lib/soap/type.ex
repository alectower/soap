defmodule Soap.Type do
  @moduledoc """
  Provides functions for parsing types to struct
  """

  import SweetXml, except: [parse: 1]

  @spec get_complex_types(String.t(), String.t()) :: list()
  def get_complex_types(wsdl, x_path) do
    wsdl_target_ns = xpath(wsdl, ~x"//*[local-name() = 'definitions']/@targetNamespace"s)

    case xpath(wsdl, ~x"//*[local-name() = 'schema']"l) do
      [] ->
        wsdl
        |> xpath(~x"#{x_path}"l)
        |> Enum.reduce(%{}, &parse_types(&1, &2, {"", "", wsdl_target_ns}))

      schemas ->
        Enum.reduce(schemas, %{}, fn schema_node, acc ->
          schema_tns = xpath(schema_node, ~x"./@targetNamespace"s)
          schema_efd = xpath(schema_node, ~x"./@elementFormDefault"s)

          schema_node
          |> xpath(~x"./*[local-name() = 'complexType']"l)
          |> Enum.reduce(acc, &parse_types(&1, &2, {schema_tns, schema_efd, wsdl_target_ns}))
        end)
    end
  end

  @spec parse_types(map(), map(), tuple()) :: map()
  defp parse_types(type_node, complex_type_acc, schema_info) do
    direct_elements =
      xpath(
        type_node,
        ~x"./*[local-name() = 'sequence' or local-name() = 'all' or local-name() = 'choice']/*[local-name() = 'element']"l
      )

    extension_elements =
      xpath(
        type_node,
        ~x"./*[local-name() = 'complexContent']/*[local-name() = 'extension']/*[local-name() = 'sequence' or local-name() = 'all' or local-name() = 'choice']/*[local-name() = 'element']"l
      )

    types_map =
      (direct_elements ++ extension_elements)
      |> Enum.reduce(%{}, &parse_type_attributes(&1, &2, schema_info))

    Map.put(complex_type_acc, type_node |> xpath(~x"./@name"s) |> String.downcase(), types_map)
  end

  @spec parse_type_attributes(map(), map(), tuple()) :: map()
  defp parse_type_attributes(inner_node, element_acc, {schema_tns, schema_efd, wsdl_target_ns}) do
    result_map =
      [:nillable, :minOccurs, :maxOccurs]
      |> Enum.reduce(%{type: inner_node |> xpath(~x"./@type"s)}, fn attr, init_map_acc ->
        attr_val = inner_node |> xpath(~x"./@#{attr}"s)

        case attr_val do
          "" -> init_map_acc
          _ -> Map.put(init_map_acc, attr, attr_val)
        end
      end)

    form = inner_node |> xpath(~x"./@form"s)

    result_map =
      cond do
        form == "qualified" and schema_tns != "" ->
          Map.put(result_map, :namespace, schema_tns)

        form != "unqualified" and schema_efd == "qualified" and schema_tns != "" and
            wsdl_target_ns != "" and schema_tns != wsdl_target_ns ->
          Map.put(result_map, :namespace, schema_tns)

        true ->
          result_map
      end

    Map.put(element_acc, inner_node |> xpath(~x"./@name"s), result_map)
  end
end
