defmodule Soap.WsdlTest do
  use ExUnit.Case
  doctest Soap.Wsdl
  alias Soap.Wsdl
  import Mock

  @wsdl Fixtures.load_wsdl("SendService.wsdl")

  @parsed_wsdl %{
    complex_types: [
      %{
        name: "sendMessageMultipleRecipientsResponse",
        type: "tns:sendMessageMultipleRecipientsResponse"
      },
      %{
        name: "sendMessageMultipleRecipients",
        type: "tns:sendMessageMultipleRecipients"
      },
      %{name: "sendMessageResponse", type: "tns:sendMessageResponse"},
      %{name: "sendMessage", type: "tns:sendMessage"}
    ],
    endpoint: "http://localhost:8080/soap/SendService",
    namespaces: %{
      "soap" => %{
        type: :soap,
        value: "http://schemas.xmlsoap.org/wsdl/soap/"
      },
      "soap12" => %{
        type: :soap,
        value: "http://schemas.xmlsoap.org/wsdl/soap12/"
      },
      "tns" => %{type: :wsdl, value: "com.esendex.ems.soapinterface"},
      "wsdl" => %{
        type: :soap,
        value: "http://schemas.xmlsoap.org/wsdl/"
      }
    },
    operations: [
      %{
        name: "SendMessage",
        soap_action: "com.esendex.ems.soapinterface/SendMessage",
        input: %{body: nil, header: nil}
      },
      %{
        name: "SendMessageMultipleRecipients",
        soap_action: "com.esendex.ems.soapinterface/SendMessageMultipleRecipients",
        input: %{body: nil, header: nil}
      }
    ],
    schema_attributes: %{
      element_form_default: "qualified",
      target_namespace: "com.esendex.ems.soapinterface"
    },
    validation_types: %{
      "recipients" => %{
        "recipient" => %{maxOccurs: "unbounded", minOccurs: "0", type: "xsd:string"}
      },
      "results" => %{
        "result" => %{maxOccurs: "unbounded", minOccurs: "0", type: "xsd:string"}
      },
      "sendmessage" => %{
        "body" => %{minOccurs: "0", type: "xsd:string"},
        "recipient" => %{minOccurs: "0", type: "xsd:string"},
        "type" => %{type: "xsd:string"},
        "date" => %{type: "xsd:date"},
        "dateTime" => %{type: "xsd:dateTime"}
      },
      "sendmessagemultiplerecipients" => %{
        "body" => %{minOccurs: "0", type: "xsd:string"},
        "recipients" => %{minOccurs: "0", type: "tns:recipients"},
        "type" => %{type: "xsd:string"},
        "dateTimes" => %{minOccurs: "0", type: "tns:dateTimes"},
        "dates" => %{minOccurs: "0", type: "tns:dates"}
      },
      "sendmessagemultiplerecipientsresponse" => %{
        "results" => %{minOccurs: "0", type: "tns:results"}
      },
      "sendmessageresponse" => %{
        "sendMessageResult" => %{minOccurs: "0", type: "xsd:string"}
      },
      "dates" => %{
        "date" => %{maxOccurs: "unbounded", minOccurs: "0", type: "xsd:date"}
      },
      "datetimes" => %{
        "dateTime" => %{maxOccurs: "unbounded", minOccurs: "0", type: "xsd:dateTime"}
      }
    },
    soap_version: "1.1",
    messages: [
      %{name: "SendMessageSoapIn", parts: [%{element: "tns:sendMessage", name: "parameters"}]},
      %{name: "SendMessageSoapOut", parts: [%{element: "tns:sendMessageResponse", name: "parameters"}]},
      %{
        name: "SendMessageMultipleRecipientsSoapIn",
        parts: [%{element: "tns:sendMessageMultipleRecipients", name: "parameters"}]
      },
      %{
        name: "SendMessageMultipleRecipientsSoapOut",
        parts: [%{element: "tns:sendMessageMultipleRecipientsResponse", name: "parameters"}]
      }
    ]
  }

  @parsed_wsdl_soap12 %{
    complex_types: [
      %{
        name: "sendMessageMultipleRecipientsResponse",
        type: "tns:sendMessageMultipleRecipientsResponse"
      },
      %{
        name: "sendMessageMultipleRecipients",
        type: "tns:sendMessageMultipleRecipients"
      },
      %{name: "sendMessageResponse", type: "tns:sendMessageResponse"},
      %{name: "sendMessage", type: "tns:sendMessage"}
    ],
    endpoint: "http://localhost:8080/soap/SendService",
    namespaces: %{
      "soap" => %{
        type: :soap,
        value: "http://schemas.xmlsoap.org/wsdl/soap/"
      },
      "soap12" => %{
        type: :soap,
        value: "http://schemas.xmlsoap.org/wsdl/soap12/"
      },
      "tns" => %{type: :wsdl, value: "com.esendex.ems.soapinterface"},
      "wsdl" => %{
        type: :soap,
        value: "http://schemas.xmlsoap.org/wsdl/"
      }
    },
    operations: [
      %{
        name: "SendMessage",
        soap_action: "com.esendex.ems.soapinterface/SendMessage12",
        input: %{body: nil, header: nil}
      },
      %{
        name: "SendMessageMultipleRecipients",
        soap_action: "com.esendex.ems.soapinterface/SendMessageMultipleRecipients12",
        input: %{body: nil, header: nil}
      }
    ],
    schema_attributes: %{
      element_form_default: "qualified",
      target_namespace: "com.esendex.ems.soapinterface"
    },
    validation_types: %{
      "recipients" => %{
        "recipient" => %{maxOccurs: "unbounded", minOccurs: "0", type: "xsd:string"}
      },
      "results" => %{
        "result" => %{maxOccurs: "unbounded", minOccurs: "0", type: "xsd:string"}
      },
      "sendmessage" => %{
        "body" => %{minOccurs: "0", type: "xsd:string"},
        "recipient" => %{minOccurs: "0", type: "xsd:string"},
        "type" => %{type: "xsd:string"},
        "date" => %{type: "xsd:date"},
        "dateTime" => %{type: "xsd:dateTime"}
      },
      "sendmessagemultiplerecipients" => %{
        "body" => %{minOccurs: "0", type: "xsd:string"},
        "recipients" => %{minOccurs: "0", type: "tns:recipients"},
        "type" => %{type: "xsd:string"},
        "dateTimes" => %{minOccurs: "0", type: "tns:dateTimes"},
        "dates" => %{minOccurs: "0", type: "tns:dates"}
      },
      "sendmessagemultiplerecipientsresponse" => %{
        "results" => %{minOccurs: "0", type: "tns:results"}
      },
      "sendmessageresponse" => %{
        "sendMessageResult" => %{minOccurs: "0", type: "xsd:string"}
      },
      "dates" => %{
        "date" => %{maxOccurs: "unbounded", minOccurs: "0", type: "xsd:date"}
      },
      "datetimes" => %{
        "dateTime" => %{maxOccurs: "unbounded", minOccurs: "0", type: "xsd:dateTime"}
      }
    },
    soap_version: "1.2",
    messages: [
      %{name: "SendMessageSoapIn", parts: [%{element: "tns:sendMessage", name: "parameters"}]},
      %{name: "SendMessageSoapOut", parts: [%{element: "tns:sendMessageResponse", name: "parameters"}]},
      %{
        name: "SendMessageMultipleRecipientsSoapIn",
        parts: [%{element: "tns:sendMessageMultipleRecipients", name: "parameters"}]
      },
      %{
        name: "SendMessageMultipleRecipientsSoapOut",
        parts: [%{element: "tns:sendMessageMultipleRecipientsResponse", name: "parameters"}]
      }
    ]
  }

  @parsed_root_namespace_wsdl %{
    complex_types: [
      %{name: "TradePriceRequest", type: ""},
      %{name: "TradePrice", type: ""}
    ],
    endpoint: "http://example.com/stockquote",
    namespaces: %{
      "" => %{type: :soap, value: "http://schemas.xmlsoap.org/wsdl/"},
      "soap" => %{type: :soap, value: "http://schemas.xmlsoap.org/wsdl/soap/"},
      "tns" => %{type: :wsdl, value: "http://example.com/stockquote.wsdl"},
      "xsd1" => %{type: :soap, value: "http://example.com/stockquote.xsd"}
    },
    operations: [
      %{
        name: "GetLastTradePrice",
        soap_action: "http://example.com/GetLastTradePrice",
        input: %{body: nil, header: nil}
      }
    ],
    schema_attributes: %{
      element_form_default: "",
      target_namespace: "http://example.com/stockquote.xsd"
    },
    validation_types: %{},
    soap_version: "1.1",
    messages: [
      %{name: "GetLastTradePriceInput", parts: [%{element: "xsd1:TradePriceRequest", name: "body"}]},
      %{name: "GetLastTradePriceOutput", parts: [%{element: "xsd1:TradePrice", name: "body"}]}
    ]
  }

  @parsed_soap_headers_wsdl %{
    complex_types: [
      %{name: "sayHelloResponse", type: "tns:sayHelloResponse"},
      %{name: "sayHello", type: "tns:sayHello"},
      %{name: "sayHelloHeader", type: "tns:sayHelloHeader"}
    ],
    endpoint: "http://localhost:8888/hello-service/hello-service",
    namespaces: %{
      "soap" => %{type: :soap, value: "http://schemas.xmlsoap.org/wsdl/soap/"},
      "tns" => %{type: :wsdl, value: "http://test.com"},
      "" => %{type: :soap, value: "http://schemas.xmlsoap.org/wsdl/"},
      "xsd" => %{type: :soap, value: "http://www.w3.org/2001/XMLSchema"}
    },
    operations: [
      %{
        input: %{body: nil, header: %{message: "tns:HelloHeader", part: "Authentication"}},
        name: "sayHello",
        soap_action: "http://example.com/sayHello"
      }
    ],
    schema_attributes: %{element_form_default: "qualified", target_namespace: "http://test.com"},
    soap_version: "1.1",
    validation_types: %{
      "sayhello" => %{
        "body" => %{type: "xsd:string"}
      },
      "sayhelloheader" => %{
        "token" => %{maxOccurs: "1", minOccurs: "1", type: "xsd:string"}
      },
      "sayhelloresponse" => %{
        "body" => %{type: "xsd:string"}
      }
    },
    messages: [
      %{name: "HelloHeader", parts: [%{element: "tns:sayHelloHeader", name: "Authentication"}]},
      %{name: "HelloMessage", parts: [%{element: "tns:sayHello", name: "parameters"}]},
      %{name: "HelloMessageResponse", parts: [%{element: "tns:sayHelloResponse", name: "parameters"}]}
    ]
  }

  test "#parse_from_file returns {:ok, wsdl}" do
    wsdl_path = Fixtures.get_file_path("wsdl/SendService.wsdl")
    assert(Wsdl.parse_from_file(wsdl_path) == {:ok, @parsed_wsdl})
  end

  test "#parse_from_url returns {:ok, wsdl}" do
    with_mock HTTPoison, get!: fn _, _, _ -> %HTTPoison.Response{body: @wsdl} end do
      assert Wsdl.parse_from_url("any_url") == {:ok, @parsed_wsdl}
    end
  end

  test "#parse returns {:ok, wsdl}" do
    assert Wsdl.parse(@wsdl, "SendService.wsdl") == {:ok, @parsed_wsdl}
  end

  test "support for root namespaces" do
    wsdl_path = Fixtures.get_file_path("wsdl/RootNamespace.wsdl")
    assert(Wsdl.parse_from_file(wsdl_path) == {:ok, @parsed_root_namespace_wsdl})
  end

  test "custom SOAP version on WSDL level" do
    wsdl_path = Fixtures.get_file_path("wsdl/SendService.wsdl")
    assert(Wsdl.parse_from_file(wsdl_path, soap_version: "1.2") == {:ok, @parsed_wsdl_soap12})
  end

  test "header definitions are loaded" do
    wsdl_path = Fixtures.get_file_path("wsdl/SoapHeader.wsdl")
    assert(Wsdl.parse_from_file(wsdl_path) == {:ok, @parsed_soap_headers_wsdl})
  end

  test "supports scoped xs:schema prefix, multiple schemas, empty soapAction, and import without schemaLocation" do
    wsdl = """
    <?xml version="1.0" encoding="utf-8"?>
    <wsdl:definitions xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
                      xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
                      xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/"
                      xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                      xmlns:tns="http://example.com/cb"
                      targetNamespace="http://example.com/cb">
      <wsdl:types>
        <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
                   targetNamespace="http://www.w3.org/1999/xlink"/>
        <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
                   targetNamespace="http://example.com/cb"
                   elementFormDefault="qualified">
          <xs:import namespace="http://www.w3.org/1999/xlink"/>
          <xs:element name="PingURL" type="tns:PingURL"/>
          <xs:complexType name="PingURL">
            <xs:sequence>
              <xs:element name="message" type="xs:string" minOccurs="0"/>
            </xs:sequence>
          </xs:complexType>
        </xs:schema>
      </wsdl:types>
      <wsdl:binding name="CBSoap" type="tns:CBSoap">
        <wsdl:operation name="PingURL">
          <soap:operation soapAction="" style="document"/>
          <wsdl:input><soap:body use="literal"/></wsdl:input>
        </wsdl:operation>
      </wsdl:binding>
      <wsdl:binding name="CBSoap12" type="tns:CBSoap">
        <wsdl:operation name="PingURL12">
          <soap12:operation soapAction="" style="document"/>
          <wsdl:input><soap12:body use="literal"/></wsdl:input>
        </wsdl:operation>
      </wsdl:binding>
    </wsdl:definitions>
    """

    {:ok, parsed} = Wsdl.parse(wsdl, "cb.wsdl")

    assert parsed.schema_attributes == %{
             element_form_default: "qualified",
             target_namespace: "http://example.com/cb"
           }

    assert parsed.complex_types == [%{name: "PingURL", type: "tns:PingURL"}]
    assert parsed.validation_types == %{"pingurl" => %{"message" => %{minOccurs: "0", type: "xs:string"}}}
    assert parsed.operations == [
             %{name: "PingURL", soap_action: "", input: %{body: nil, header: nil}}
           ]
  end
end
