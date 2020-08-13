extends Reference

const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")
const EnjinGraphqlRequest = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd")
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func create_request_body(request: EnjinGraphqlRequest) -> Dictionary:
    var query: String = _middleware\
    .get_registry()\
    .get_template(request.get_namespace())\
    .get_compiled_contents()
    var variables: Dictionary = request.get_vars()
    return {"query": query, "variables": variables}

func send_request(call: EnjinCall, callback: EnjinCallback, udata: Dictionary):
    _middleware.get_http().enqueue(call, callback, udata)
