extends Reference

const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")
const EnjinGraphqlRequest = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlRequest.gd")
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware
var _schema: String

func _init(middleware: TrustedPlatformMiddleware, schema: String):
    _middleware = middleware
    _schema = schema

func create_request_body(request: EnjinGraphqlRequest) -> Dictionary:
    var query: String = _middleware.get_registry()\
                                   .get_template(request.get_namespace())\
                                   .get_compiled_contents()
    var variables: Dictionary = request.get_vars()
    return {"query": query, "variables": variables}

func send_request(call: EnjinCall, udata: Dictionary = {}, callback: EnjinCallback = null):
    if callback != null:
        udata.callback = callback
    _middleware.execute_gql(call, udata)
