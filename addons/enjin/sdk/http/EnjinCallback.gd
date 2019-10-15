extends Reference
class_name EnjinCallback

var instance: Object setget ,get_instance
var method: String setget ,get_method

func _init(instance_in: Object, method_in: String):
    instance = instance_in
    method = method_in

func get_instance() -> Object:
    return instance

func get_method() -> String:
    return method

func complete_deffered_0():
    instance.call_deferred(method)

func complete_deffered_1(arg1):
    instance.call_deferred(method, arg1)

func complete_deffered_2(arg1, arg2):
    instance.call_deferred(method, arg1, arg2)

func complete_deffered_3(arg1, arg2, arg3):
    instance.call_deferred(method, arg1, arg2, arg3)