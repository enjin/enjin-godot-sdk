extends Node
class_name EnjinCall

var method: int = HTTPClient.METHOD_GET setget set_method, get_method
var endpoint: String setget set_endpoint, get_endpoint
var body: String setget set_body, get_body

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