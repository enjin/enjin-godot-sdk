extends "res://addons/gut/test.gd"

const EnjinHttpServer = preload("res://addons/enjin/sdk/tests/EnjinHttpServer.gd")

const EnjinHttp = preload("res://addons/enjin/sdk/http/EnjinHttp.gd")
const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")
const EnjinEndpoints = preload("res://addons/enjin/sdk/http/EnjinEndpoints.gd")
const EnjinContentTypes = preload("res://addons/enjin/sdk/http/EnjinContentTypes.gd")

const Spy = preload('res://addons/gut/spy.gd')

var enjin_http_server = null
var enjin_http_client = null
var call_spy = null


func before_all():
    enjin_http_server = EnjinHttpServer.new()
    enjin_http_server.Start()
    
    enjin_http_client = EnjinHttp.new("127.0.0.1", 8080, false, false)
    call_spy = Spy.new()

func before_each():
    pass

func after_each():
    pass

func after_all():
    enjin_http_server.free()
    gut.p("stopping server")
    
func test_EnjinHttp():
    gut.p("running test_call()")
    var call = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(EnjinEndpoints.GRAPHQL)
    call.set_content_type(EnjinContentTypes.TEXT_PLAIN_ASCII)
    call.set_body("{}")
    
    var DoubledResponse = double(preload("res://addons/enjin/sdk/tests/double_response.gd"))
    var doubled_class_instance = DoubledResponse.new()
    
    var callback = EnjinCallback.new(doubled_class_instance, "_on_callback_2")
    
    # Enqueue Request
    enjin_http_client.enqueue(call, callback)
    
    gut.simulate(enjin_http_server, 1000, 1)
    
    yield(yield_for(1), YIELD)
    
    assert_called(doubled_class_instance, "_on_callback_2")
    
    doubled_class_instance.free()
