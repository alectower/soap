defmodule Soap.Request.Headers do
  @moduledoc """
  Headers generator by soap action and custom headers.

  ## Examples

      iex> {:ok, wsdl} = Fixtures.get_file_path("wsdl/SendService.wsdl") |> Soap.init_model(:file)
      ...> Soap.Request.Headers.build(wsdl, "SendMessage", [])
      [{"SOAPAction", "com.esendex.ems.soapinterface/SendMessage"}, {"Content-Type", "text/xml;charset=utf-8"}]

  """

  @spec build(map(), String.t(), list()) :: list()
  def build(wsdl, operation, custom_headers) do
    wsdl
    |> extract_soap_action_by_operation(operation)
    |> extract_headers(custom_headers)
  end

  @spec extract_soap_action_by_operation(map(), String.t()) :: String.t()
  defp extract_soap_action_by_operation(wsdl, operation) do
    Enum.find(wsdl[:operations], fn x -> x[:name] == operation end)[:soap_action]
  end

  @spec extract_headers(String.t(), list()) :: list()
  defp extract_headers(soap_action, custom_headers) do
    base_headers(soap_action)
    |> merge_headers(custom_headers)
  end

  @spec base_headers(String.t()) :: list()
  defp base_headers(soap_action) do
    [{"SOAPAction", soap_action}, {"Content-Type", "text/xml;charset=utf-8"}]
  end

  def merge_headers(x, y) do
    Enum.map(x, fn {k, _} = c ->
      {
        k,
        Enum.find(y, c, fn {k1, _} ->
          to_string(k) == to_string(k1)
        end)
        |> elem(1)
      }
    end)
  end
end
