extends Reference
class_name TrustedPlatformMiddleware

var _http: EnjinHttp
var _state: TrustedPlatformState

func _init(http: EnjinHttp, state: TrustedPlatformState):
    _http = http
    _state = state

func post(endpoint: String, body) -> EnjinCall:
    var call = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(endpoint)
    call.set_body(body)
    return call

func graphql(body):
    var call = post(EnjinEndpoints.GRAPHQL, to_json(body))
    call.set_content_type(EnjinContentTypes.APPLICATION_JSON_UTF8)
    if _state._auth_app_id != null:
        call.add_header(EnjinHeaders.X_APP_ID, _state._auth_app_id)
    if _state._auth_token != null:
        call.add_header(EnjinHeaders.AUTHORIZATION, _state._auth_token)
    return call