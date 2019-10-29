extends "res://addons/gut/test.gd"

const EnjinHttpServer = preload("res://addons/enjin/sdk/tests/EnjinHttpServer.gd")
const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")
const EnjinHttp = preload("res://addons/enjin/sdk/http/EnjinHttp.gd")
const EnjinHeaders = preload("res://addons/enjin/sdk/http/EnjinHeaders.gd")

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")

const EnjinContentTypes = preload("res://addons/enjin/sdk/http/EnjinContentTypes.gd")

var _state: TrustedPlatformState
var _middleware: TrustedPlatformMiddleware

var enjin_http_server = null
var doubled_class_instance = null

func before_all():
    enjin_http_server = EnjinHttpServer.new()
    enjin_http_server.Start()
    
    var DoubledResponse = double(preload("res://addons/enjin/sdk/tests/double_response.gd"))
    doubled_class_instance = DoubledResponse.new()

func before_each():
    var base_url = "localhost"
    var http = EnjinHttp.new(base_url, 8080, false, false)
    
    _state = TrustedPlatformState.new()
    _middleware = TrustedPlatformMiddleware.new(http, _state)

func after_each():
    pass

func after_all():
    doubled_class_instance.free()
    enjin_http_server.free()

func test_TrustedPlatformMiddleware():
    assert_not_null(_middleware._http, "_middleware._http is not set")
    assert_not_null(_middleware._state, "_middleware._state is not set")
    assert_is(_middleware._gql_callback, EnjinCallback, "_middleware._gql_callback is not of type EnjinCallback")

func test_TrustedPlatformMiddleware_post():
    var body = "body"
    var endpoint = "localhost"
    var method_str = "HTTPClient.METHOD_POST"
    
    var call : EnjinCall = _middleware.post(endpoint, body)
    assert_eq(call.get_method(), HTTPClient.METHOD_POST, "Method \"get_method()\n did not return the expected value of \"" + method_str + "\n")
    assert_eq(call.get_endpoint(), endpoint, "Method \"get_endpoint()\n did not return the expected value of \"" + endpoint + "\n")
    assert_eq(call.get_body(), body, "Method \"get_body()\n did not return the expected value of \"" + body + "\n")

func test_TrustedPlatformMiddleware_graphql():
    var call: EnjinCall = _middleware.graphql({"body": "body"})
    assert_eq(call._content_type, EnjinContentTypes.APPLICATION_JSON_UTF8)
    
    #TODO: make sure headers are present after a successful login attempt
    var token = "token"
    
    _state.auth_user(token)
    var auth_call: EnjinCall = _middleware.graphql({"body": "body"})
    var headers = auth_call.get_headers()
    
    var has_auth_token = false
    
    for header in headers:
        if header.begins_with(EnjinHeaders.AUTHORIZATION) and header.ends_with(token):
            has_auth_token = true
    
    assert_eq(has_auth_token, true, "Auth token not found in headers")
    
    _state.clear_auth()
    has_auth_token = false
    
    #Auth app
    var app_id = 201920192019
    var has_app_id = false
    _state.auth_app(app_id, token)
    
    var auth_app_call: EnjinCall = _middleware.graphql({"body": "body"})
    
    for header in auth_app_call.get_headers():
        if header.begins_with(EnjinHeaders.AUTHORIZATION) and header.ends_with(token):
            has_auth_token = true
        if header.begins_with(EnjinHeaders.X_APP_ID) and header.ends_with(str(app_id)):
            has_app_id = true
    
    assert_eq(has_auth_token, true, "Auth token not found in headers")
    assert_eq(has_app_id, true, "App ID not found in headers")

func test_TrustedPlatformMiddleware_submit_gql_request_cb():
    var gql_callback = EnjinCallback.new(doubled_class_instance, "_on_callback_2")
    
    _middleware.submit_gql_request_cb({}, gql_callback)
    
    gut.simulate(enjin_http_server, 1000, 1)
    
    yield(yield_for(1), YIELD)
    
    assert_called(doubled_class_instance, "_on_callback_2")

func test_TrustedPlatformMiddleware_process_graphql_data():
    var call = EnjinCall.new()
    
    var response = EnjinResponse.new(call, 200, {}, "body")
    var udata = {"response": response}
    _middleware.process_graphql_data(udata)
    assert_has(udata.keys(), 'gql', "udata does not contain key \"gql\"")
    assert_is(udata["gql"], EnjinGraphqlResponse, "udata.gql is not of type EnjinGraphqlResponse")

func test_TrustedPlatformMiddleware_graphql_callback():
    var callback = EnjinCallback.new(doubled_class_instance, "_on_callback_1")
    
    var call = EnjinCall.new()
    var response = EnjinResponse.new(call, 200, {}, "body")
    var udata = {"response": response, "callback": callback}
    
    _middleware._graphql_callback(udata)
    assert_has(udata.keys(), 'gql')
    
    yield(yield_for(1), YIELD)
    
    assert_called(doubled_class_instance, "_on_callback_1")
    
