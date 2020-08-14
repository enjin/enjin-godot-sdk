extends Reference

const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")
const EnjinGraphqlRequest = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd")
const EnjinHttpService = preload("res://addons/enjin/sdk/http/EnjinHttpService.gd")
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware
var _schema: String
var _http_service: EnjinHttpService

func _init(middleware: TrustedPlatformMiddleware, schema: String):
    _middleware = middleware
    _schema = schema
    _http_service = EnjinHttpService.new(_middleware)

func create_request_body(request: EnjinGraphqlRequest) -> Dictionary:
    var query: String = _middleware.get_registry()\
                                   .get_template(request.get_namespace())\
                                   .get_compiled_contents()
    var variables: Dictionary = request.get_vars()
    return {"query": query, "variables": variables}

func send_request(call: EnjinCall, callback: EnjinCallback, udata: Dictionary):
    _middleware.execute_gql(call, callback, udata)
