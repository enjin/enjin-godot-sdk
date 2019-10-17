extends Reference
class_name TrustedPlatformMiddleware

var http: EnjinHttp
var state: TrustedPlatformState

func _init(http_in: EnjinHttp, state_in: TrustedPlatformState):
    http = http_in
    state = state_in

func post(endpoint: String, body) -> EnjinCall:
    var call = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(endpoint)
    call.set_body(body)
    return call

func graphql(body):
    var call = post(EnjinEndpoints.GRAPHQL, to_json(body))
    call.set_content_type(EnjinContentTypes.APPLICATION_JSON)
    if state.auth_app_id != null:
        call.add_header(EnjinHeaders.X_APP_ID, state.auth_app_id)
    if state.auth_token != null:
        call.add_header(EnjinHeaders.AUTHORIZATION, state.auth_token)
    return call