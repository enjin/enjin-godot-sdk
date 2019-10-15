extends Reference
class_name EnjinGraphqlResponse

const DATA_KEY = "data"
const RESULT_KEY = "result"
const ITEMS_KEY = "items"
const CURSOR_KEY = "cursor"
const ERRORS_KEY = "errors"

var items
var cursor
var errors

func _init(res: EnjinResponse):
    var parse_result: JSONParseResult = JSON.parse(res.get_body())
    if parse_result == null || parse_result.get_error() != OK:
        return
    var body: Dictionary = parse_result.get_result()
    _get_items(body)
    _get_errors(body)

func _get_items(root: Dictionary):
    if !root.has(DATA_KEY):
        return
    var data = root[DATA_KEY]
    if !data.has(RESULT_KEY):
        return
    var results = data[RESULT_KEY]
    if results.has(ITEMS_KEY):
        items = results[ITEMS_KEY]
        cursor = results[CURSOR_KEY]
    else:
        items = results

func _get_errors(root: Dictionary):
    if !root.has(ERRORS_KEY):
        return
    errors = root[ERRORS_KEY]

func get_items():
    return items

func get_cursor():
    return cursor

func get_errors():
    return errors

func is_success():
    return errors == null and items != null
