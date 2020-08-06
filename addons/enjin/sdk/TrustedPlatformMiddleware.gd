extends Reference

const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")
const EnjinContentTypes = preload("res://addons/enjin/sdk/http/EnjinContentTypes.gd")
const EnjinHeaders = preload("res://addons/enjin/sdk/http/EnjinHeaders.gd")
const EnjinGraphqlQueryRegistry = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlQueryRegistry.gd")
const EnjinHttp = preload("res://addons/enjin/sdk/http/EnjinHttp.gd")
const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")

var _base_url: String setget , get_base_url
var _schema: String setget , get_schema
var _state: TrustedPlatformState
var _http: EnjinHttp setget , get_http
var _registry: EnjinGraphqlQueryRegistry setget , get_registry
var _gql_callback: EnjinCallback

func _init(base_url: String,
           debug: bool,
           schema: String,
           state: TrustedPlatformState):
    _base_url = base_url
    _schema = schema
    _state = state
    _http = EnjinHttp.new(_base_url)
    _registry = EnjinGraphqlQueryRegistry.new()
    _gql_callback = EnjinCallback.new(self, "_graphql_callback")

func execute_post(call: EnjinCall, udata: Dictionary = {}):
    execute_post_cb(call, udata.callback, udata)

func execute_post_cb(call: EnjinCall,
                     callback: EnjinCallback,
                     udata: Dictionary = {}):
    _http.enqueue(call, callback, udata)

func execute_gql(schema: String,
                 op_name: String,
                 vars: Dictionary = {},
                 udata: Dictionary = {},
                 callback = _gql_callback):
    var body = _registry.build_request_body(op_name, vars)
    var call: EnjinCall = _graphql(schema, body)
    udata.call = call
    _http.enqueue(call, callback, udata)

func post(endpoint: String, body: String, content_type: String) -> EnjinCall:
    var call: EnjinCall = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(endpoint)
    call.set_body(body)
    call.set_content_type(content_type)
    return call

func process_graphql_data(udata: Dictionary):
    var response: EnjinResponse = udata.response
    if response != null and response.has_body():
        udata.gql = EnjinGraphqlResponse.new(response)

func _graphql(schema: String, body: Dictionary = {}) -> EnjinCall:
    var path: String = '/graphql/%s' % schema
    var call: EnjinCall = post(path, to_json(body), EnjinContentTypes.APPLICATION_JSON_UTF8)

    if _state._auth_app_id != null:
        call.add_header(EnjinHeaders.X_APP_ID, str(_state._auth_app_id))
    if _state._auth_token != null:
        call.add_header(EnjinHeaders.AUTHORIZATION, _state._auth_token)
    return call

func _graphql_callback(udata: Dictionary):
    var callback: EnjinCallback = udata.callback if udata.has("callback") else null
    if callback == null:
        return
    process_graphql_data(udata)
    callback.complete_deffered_1(udata)

func get_base_url() -> String:
    return _base_url

func get_schema() -> String:
    return _schema

func get_http() -> EnjinHttp:
    return _http

func get_registry() -> EnjinGraphqlQueryRegistry:
    return _registry
