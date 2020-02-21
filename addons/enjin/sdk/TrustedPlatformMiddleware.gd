extends Reference

const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")
const EnjinHttp = preload("res://addons/enjin/sdk/http/EnjinHttp.gd")
const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")
const EnjinEndpoints = preload("res://addons/enjin/sdk/http/EnjinEndpoints.gd")
const EnjinContentTypes = preload("res://addons/enjin/sdk/http/EnjinContentTypes.gd")
const EnjinHeaders = preload("res://addons/enjin/sdk/http/EnjinHeaders.gd")
const EnjinGraphqlSchema = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlSchema.gd")

var _http: EnjinHttp
var _state: TrustedPlatformState
var _schema: EnjinGraphqlSchema
var _gql_callback: EnjinCallback

func _init(http: EnjinHttp, state: TrustedPlatformState):
    _http = http
    _state = state
    _schema = EnjinGraphqlSchema.new()
    _gql_callback = EnjinCallback.new(self, "_graphql_callback")

func execute_post(call: EnjinCall, udata: Dictionary = {}):
    execute_post_cb(call, udata.callback, udata)

func execute_post_cb(call: EnjinCall, callback: EnjinCallback, udata: Dictionary = {}):
    _http.enqueue(call, callback, udata)

func execute_gql(op_name: String, vars: Dictionary = {}, udata: Dictionary = {}, callback = _gql_callback):
    var body = _schema.build_request_body(op_name, vars)
    var call = _graphql(body)
    udata.call = call
    _http.enqueue(call, callback, udata)

func post(endpoint: String, body: String, content_type: String) -> EnjinCall:
    var call = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(endpoint)
    call.set_body(body)
    call.set_content_type(content_type)
    return call

func process_graphql_data(udata: Dictionary):
    var response: EnjinResponse = udata.response
    if response != null and response.has_body():
        udata.gql = EnjinGraphqlResponse.new(response)

func _graphql(body: Dictionary = {}):
    var call = post(EnjinEndpoints.GRAPHQL, to_json(body), EnjinContentTypes.APPLICATION_JSON_UTF8)
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
