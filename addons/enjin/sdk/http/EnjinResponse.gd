extends Reference
class_name EnjinResponse

const EnjinCall = preload("res://addons/enjin/sdk/http/EnjinCall.gd")

var _request: EnjinCall setget ,get_call
var _code: int setget ,get_code
var _headers: Dictionary setget ,get_headers
var _body: String setget ,get_body

func _init(request: EnjinCall, code: int, headers: Dictionary, body: String):
    _request = request
    _code = code
    _headers = headers
    _body = body

func get_call() -> EnjinCall:
    return _request

func get_code() -> int:
    return _code

func get_headers() -> Dictionary:
    return _headers

func get_body() -> String:
    return _body

func is_success() -> bool:
    return _code >= 200 and _code < 300

func has_body() -> bool:
    return _body.length() > 0
