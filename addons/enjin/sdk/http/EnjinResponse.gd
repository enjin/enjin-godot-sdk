extends Reference
class_name EnjinResponse

var request: EnjinCall setget ,get_call
var code: int setget ,get_code
var headers: Dictionary setget ,get_headers
var body: String setget ,get_body

func _init(request_in: EnjinCall, code_in: int, headers_in: Dictionary, body_in: String):
    request = request_in
    code = code_in
    headers = headers_in
    body = body_in

func get_call() -> EnjinCall:
    return request

func get_code() -> int:
    return code

func get_headers() -> Dictionary:
    return headers

func get_body() -> String:
    return body

func is_success() -> bool:
    return code >= 200 and code < 300