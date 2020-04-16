extends Reference
class_name EnjinGraphqlResponse

const DATA_KEY = "data"
const RESULT_KEY = "result"
const ITEMS_KEY = "items"
const CURSOR_KEY = "cursor"
const ERRORS_KEY = "errors"

var _http_response: EnjinResponse
var _result
var _cursor
var _errors

func _init(http_response: EnjinResponse):
    _http_response = http_response
    if http_response.get_body().length() == 0 || http_response.get_body() == "failed":
        return
    var parse_result: JSONParseResult = JSON.parse(http_response.get_body())
    if parse_result == null || parse_result.get_error() != OK:
        return
    var body: Dictionary = parse_result.get_result()
    _get_result(body)
    _get_errors(body)

func _get_result(root: Dictionary):
    # Check if value is assigned to data field
    if !root.has(DATA_KEY) or root.get(DATA_KEY) == null:
        return
    var data = root[DATA_KEY]
    # Check if value is assigned to result field
    if !data.has(RESULT_KEY) or data.get(RESULT_KEY) == null:
        return
    var result = data[RESULT_KEY]
    # Check if the data is paginated
    if result.has(ITEMS_KEY):
        _result = result[ITEMS_KEY]
        _cursor = result[CURSOR_KEY]
    else:
        _result = result

func _get_errors(root: Dictionary):
    if !root.has(ERRORS_KEY) || root.get(ERRORS_KEY) == null:
        return
    _errors = root[ERRORS_KEY]

func get_result():
    return _result

func get_cursor():
    return _cursor

func get_errors():
    return _errors

func has_result() -> bool:
    return _result != null

func is_paginated() -> bool:
    return _cursor != null

func has_errors() -> bool:
    return _errors != null
