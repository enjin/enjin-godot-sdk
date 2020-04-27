extends Reference

const EnjinContentTypes = preload("res://addons/enjin/sdk/http/EnjinContentTypes.gd")
const TrustedPlatformConstants = preload("res://addons/enjin/sdk/TrustedPlatformConstants.gd")

var _method: int = HTTPClient.METHOD_GET setget set_method, get_method
var _endpoint: String setget set_endpoint, get_endpoint
var _body: String = "" setget set_body, get_body
var _content_type = EnjinContentTypes.TEXT_PLAIN_ASCII
var _headers = []

func set_method(method: int):
    _method = method

func get_method() -> int:
    return _method

func set_endpoint(endpoint: String):
    _endpoint = endpoint

func get_endpoint() -> String:
    return _endpoint

func set_body(body: String):
    _body = body

func get_body() -> String:
    return _body

func set_content_type(content_type: String):
    _content_type = content_type

func add_header(key: String, value: String):
    _headers.push_back("%s: %s" % [key, value])

func get_headers() -> Array:
    var headers = _headers.duplicate()
    headers.push_back("Content-Type: %s" % _content_type)
    headers.push_back("Content-Length: %s" % str(_body.length()))
    headers.push_back("User-Agent: Enjin Godot SDK v%s" % TrustedPlatformConstants.VERSION)
    return headers
