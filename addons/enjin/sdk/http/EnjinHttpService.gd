extends Reference

const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")
const EnjinContentTypes = preload("res://addons/enjin/sdk/http/EnjinContentTypes.gd")
const EnjinHeaders = preload("res://addons/enjin/sdk/http/EnjinHeaders.gd")
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func post(schema: String, request: Dictionary) -> EnjinCall:
    var call: EnjinCall = _create_call("/graphql/%s" % schema, to_json(request))
    var state: TrustedPlatformState = _middleware.get_state()
    if state._auth_app_id != null:
        call.add_header(EnjinHeaders.X_APP_ID, str(state._auth_app_id))
    if state._auth_token != null:
        call.add_header(EnjinHeaders.AUTHORIZATION, state._auth_token)
    return call

func _create_call(path: String, body: String) -> EnjinCall:
    var call: EnjinCall = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(path)
    call.set_body(body)
    call.set_content_type(EnjinContentTypes.APPLICATION_JSON_UTF8)
    return call
