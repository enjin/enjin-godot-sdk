extends Reference
class_name BaseService

const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")
const EnjinCallback = preload("res://addons/enjin/sdk/http/EnjinCallback.gd")
const EnjinVariableHolder = preload("res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd")
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func create_request_body(holder: EnjinVariableHolder, template: String) -> Dictionary:
    var query: String = _middleware.get_registry().get_template(template).get_compiled_template()
    var variables: Dictionary = holder.vars
    return {"query": query, "variables": variables}

func send_request(call: EnjinCall, callback: EnjinCallback, udata: Dictionary):
    _middleware.get_http().enqueue(call, callback, udata)
