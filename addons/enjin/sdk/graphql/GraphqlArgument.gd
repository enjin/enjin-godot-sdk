extends Reference
class_name GraphqlArgument

var _name: String
var _type: String = ""
var _default_value: String = ""

func _init(text: String):
    var col_pos = text.find_last(":")
    var eq_pos = text.find_last("=")

    _name = text.substr(0, col_pos).trim_prefix("$")
    if eq_pos != -1:
        _type = text.substr(col_pos + 1, eq_pos - col_pos - 1).strip_edges()
        _default_value = text.substr(eq_pos + 1, text.length() - eq_pos - 1).strip_edges()
    else:
        _type = text.substr(col_pos + 1, text.length() - col_pos - 1).strip_edges()

func to_string() -> String:
    var val: String = "$%s: %s" % [_name, _type]
    if _default_value != "":
        val = "%s = %s" % [val, _default_value]
    return val