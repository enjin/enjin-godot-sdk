extends Reference
class_name EnjinCall

var method: int = HTTPClient.METHOD_GET setget set_method, get_method
var endpoint: String setget set_endpoint, get_endpoint
var body: String = "" setget set_body, get_body
var content_type = "text/plain; charset=\"us-ascii\""
var headers = []

func set_method(method_in: int):
    method = method_in

func get_method() -> int:
    return method

func set_endpoint(endpoint_in: String):
    endpoint = endpoint_in

func get_endpoint() -> String:
    return endpoint

func set_body(body_in: String):
    body = body_in

func get_body() -> String:
    return body

func set_content_type(content_type_in: String):
    content_type = content_type_in

func add_header(key: String, value: String):
    headers.push_back("%s: %s" % [key, value])

func get_headers() -> Array:
    var headers_out = headers.duplicate()
    headers_out.push_back("Content-Type: %s" % content_type)
    headers_out.push_back("Content-Length: %s" % str(body.length()))
    return headers