defmodule Soap.Xsd do
  @moduledoc """
  Provides functions for parsing xsd file
  """

  import SweetXml, except: [parse: 1]

  alias Soap.Type

  @spec parse(String.t()) :: {:ok, map()} | {:error, atom()}
  def parse(path) do
    if URI.parse(path).scheme do
      parse_from_url(path)
    else
      parse_from_file(path)
    end
  end

  @spec parse_from_file(String.t()) :: {:ok, map()} | {:error, atom()}
  def parse_from_file(path) do
    case File.read(path) do
      {:ok, xsd} -> parse_xsd(xsd)
      error_response -> error_response
    end
  end

  @spec parse_from_url(String.t()) :: {:ok, map()} | {:error, atom()}
  def parse_from_url(path) do
    case HTTPoison.get(path, [], follow_redirect: true, max_redirect: 5) do
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, :not_found}
      {:ok, %HTTPoison.Response{body: body}} -> parse_xsd(body)
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  @spec parse(String.t()) :: {:ok, map()}
  defp parse_xsd(xsd) do
    parsed_response = %{
      simple_types: get_simple_types(xsd),
      complex_types: Type.get_complex_types(xsd, "//*[local-name() = 'schema']/*[local-name() = 'complexType']")
    }

    {:ok, parsed_response}
  end

  @spec get_simple_types(String.t()) :: list()
  defp get_simple_types(wsdl) do
    wsdl
    |> xpath(
      ~x"//*[local-name() = 'schema']/*[local-name() = 'simpleType']"l,
      name: ~x"./@name"s,
      restriction: [
        ~x"./*[local-name() = 'restriction']"o,
        base: ~x"./@base"s,
        min_inclusive: ~x"./*[local-name() = 'minInclusive']/@value"io,
        max_inclusive: ~x"./*[local-name() = 'maxInclusive']/@value"io,
        max_length: ~x"./*[local-name() = 'maxLength']/@value"io,
        total_digits: ~x"./*[local-name() = 'totalDigits']/@value"io,
        fraction_digits: ~x"./*[local-name() = 'fractionDigits']/@value"io,
        pattern: ~x"./*[local-name() = 'pattern']/@value"so,
        enumeration: ~x"./*[local-name() = 'enumeration']/@value"lso
      ],
      list: [
        ~x"./*[local-name() = 'list']"o,
        item_type: ~x"./@itemType"s
      ],
      union: [
        ~x"./*[local-name() = 'union']"o,
        types: ~x"./*[local-name() = 'simpleType']/*[local-name() = 'restriction']/@base"lo
      ]
    )
  end
end
