extends Reference
class_name EnjinCallback

var _instance: Object setget ,get_instance
var _method: String setget ,get_method

func _init(instance: Object, method: String):
    _instance = instance
    _method = method

func get_instance() -> Object:
    return _instance

func get_method() -> String:
    return _method

func complete_deffered_0():
    _instance.call_deferred(_method)

func complete_deffered_1(arg1):
    _instance.call_deferred(_method, arg1)

func complete_deffered_2(arg1, arg2):
    _instance.call_deferred(_method, arg1, arg2)

func complete_deffered_3(arg1, arg2, arg3):
    _instance.call_deferred(_method, arg1, arg2, arg3)