extends Reference

const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")
const EnjinHttp = preload("res://addons/enjin/sdk/http/EnjinHttp.gd")
const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")
const EnjinEndpoints = preload("res://addons/enjin/sdk/http/EnjinEndpoints.gd")
const EnjinContentTypes = preload("res://addons/enjin/sdk/http/EnjinContentTypes.gd")
const EnjinHeaders = preload("res://addons/enjin/sdk/http/EnjinHeaders.gd")

var _http: EnjinHttp
var _state: TrustedPlatformState
var _gql_callback: EnjinCallback

func _init(http: EnjinHttp, state: TrustedPlatformState):
    _http = http
    _state = state
    _gql_callback = EnjinCallback.new(self, "_graphql_callback")

func post(endpoint: String, body: String) -> EnjinCall:
    var call = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(endpoint)
    call.set_body(body)
    return call

func graphql(body: Dictionary = {}):
    var call = post(EnjinEndpoints.GRAPHQL, to_json(body))
    call.set_content_type(EnjinContentTypes.APPLICATION_JSON_UTF8)
    if _state._auth_app_id != null:
        call.add_header(EnjinHeaders.X_APP_ID, _state._auth_app_id)
    if _state._auth_token != null:
        call.add_header(EnjinHeaders.AUTHORIZATION, _state._auth_token)
    return call

func submit_gql_request(body: Dictionary, udata: Dictionary = {}):
    submit_gql_request_cb(body, _gql_callback, udata)

func submit_gql_request_cb(body: Dictionary, callback: EnjinCallback, udata: Dictionary = {}):
    _http.enqueue(graphql(body), callback, udata)

func process_graphql_data(udata: Dictionary):
    var response: EnjinResponse = udata.response
    if response != null and response.has_body():
        udata.gql = EnjinGraphqlResponse.new(response)

func _graphql_callback(udata: Dictionary):
    var callback: EnjinCallback = udata.callback
    if callback == null:
        return
    process_graphql_data(udata)
    callback.complete_deffered_1(udata)