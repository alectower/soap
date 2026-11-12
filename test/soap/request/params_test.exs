defmodule Soap.Request.ParamsTest do
  use ExUnit.Case
  doctest Soap.Request.Params
  alias Soap.{Request.Params, Wsdl}
  @wsdl_path Fixtures.get_file_path("wsdl/SendService.wsdl")

  @operation "SendMessage"

  test "#build_body converts map to Xml-like string successful" do
    xml_body = Fixtures.load_xml("send_service/SendMessageRequest.xml")
    parameters = %{recipient: "WSPB", body: "BODY", type: "TYPE", date: "2018-01-19"}
    {_, wsdl} = Wsdl.parse_from_file(@wsdl_path)
    function_result = Params.build_body(wsdl, @operation, parameters, nil)

    assert function_result == xml_body
  end

  test "#build_body uses the custom WSDL SOAP version" do
    xml_body = Fixtures.load_xml("send_service/SendMessageRequest_soap12.xml")
    parameters = %{recipient: "WSPB", body: "BODY", type: "TYPE", date: "2018-01-19"}
    {_, wsdl} = Wsdl.parse_from_file(@wsdl_path, soap_version: "1.2")
    function_result = Params.build_body(wsdl, @operation, parameters, nil)

    assert function_result == xml_body
  end

  test "#build_body converts map to error list" do
    parameters = %{userID: "WSPB", type: "ertert"}
    {_, wsdl} = Wsdl.parse_from_file(@wsdl_path)
    function_result = Params.build_body(wsdl, @operation, parameters, nil)

    assert function_result == [
             "Invalid SOAP message:Invalid content was found starting with element 'userID'. One of {body, date, dateTime, recipient, type} is expected."
           ]
  end

  test "#build_body returns wrong type errors" do
    parameters = %{recipient: 1}
    {_, wsdl} = Wsdl.parse_from_file(@wsdl_path)
    function_result = Params.build_body(wsdl, @operation, parameters, nil)

    assert function_result == [
             "Element recipient has wrong type. Expects string type."
           ]
  end

  test "#build_body returns wrong date format errors" do
    parameters = %{"date" => "09:00:00"}
    {_, wsdl} = Wsdl.parse_from_file(@wsdl_path)
    function_result = Params.build_body(wsdl, @operation, parameters, nil)

    assert function_result == [
             "Element date has wrong format. Expects [0-9]{4}-[0-9]{2}-[0-9]{2} format."
           ]
  end

  test "#build_body supports inline anonymous complexType elements and missing complex_types entries" do
    wsdl_path = Fixtures.get_file_path("wsdl/RootNamespace.wsdl")
    {:ok, wsdl} = Wsdl.parse_from_file(wsdl_path)

    inline_result = Params.build_body(wsdl, "TradePriceRequest", %{tickerSymbol: "AAPL"}, nil)

    assert inline_result ==
             "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" <>
               "<env:Envelope xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\" " <>
               "xmlns:tns=\"http://example.com/stockquote.xsd\" " <>
               "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" " <>
               "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">" <>
               "<env:Header/>" <>
               "<env:Body><tns:TradePriceRequest><tickerSymbol>AAPL</tickerSymbol></tns:TradePriceRequest></env:Body>" <>
               "</env:Envelope>"

    missing_op_result = Params.build_body(wsdl, "GetLastTradePrice", %{tickerSymbol: "AAPL"}, nil)
    assert String.contains?(missing_op_result, "<tns:GetLastTradePrice><tickerSymbol>AAPL</tickerSymbol></tns:GetLastTradePrice>")
  end

  test "#build_body uses message parameters part element when RequestWrapper is specified" do
    wsdl = %{
      namespaces: %{
        "tns" => %{value: "http://www.multispeak.org/V5.0/wsdl/CB_Server", type: :wsdl},
        "env" => %{value: "http://www.w3.org/2003/05/soap-envelope", type: :soap}
      },
      soap_version: "1.2",
      schema_attributes: %{},
      complex_types: [
        %{name: "GetCustomersByContactInfo", type: ""},
        %{name: "GetCustomersByContactInfoRequestWrapper", type: "tns:GetCustomersByContactInfoRequestWrapper"}
      ],
      operations: [
        %{
          name: "GetCustomersByContactInfo",
          soap_action: "http://www.multispeak.org/Version_5.0_Release/GetCustomersByContactInfo",
          input: %{body: nil, header: nil}
        }
      ],
      messages: [
        %{
          name: "GetCustomersByContactInfo",
          parts: [
            %{name: "parameters", element: "tns:GetCustomersByContactInfoRequestWrapper"}
          ]
        }
      ],
      validation_types: %{
        "getcustomersbycontactinforequestwrapper" => %{
          "ArrayOfContactInfoReferable" => %{minOccurs: "0", type: "ns3:ArrayOfContactInfoReferable"},
          "lastReceived" => %{minOccurs: "0", type: "xs:string"}
        }
      }
    }

    body =
      Params.build_body(
        wsdl,
        "GetCustomersByContactInfo",
        [ArrayOfContactInfoReferable: [contactInfoReferable: [address1: "123 Main St"]]],
        %{}
      )

    assert String.contains?(body, "<tns:GetCustomersByContactInfoRequestWrapper>")
    refute String.contains?(body, "<tns:GetCustomersByContactInfo>")

    invalid =
      Params.build_body(
        wsdl,
        "GetCustomersByContactInfo",
        [lastReceived: 123],
        %{}
      )

    assert invalid == ["Element lastReceived has wrong type. Expects string type."]
  end
end
