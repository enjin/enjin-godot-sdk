extends Node
class_name EnjinCallback

var instance: Object setget , get_instance
var method: String setget , get_method

func get_instance() -> Object:
    return instance

func get_method() -> String:
    return method

func _init(instance_in: Object, method_in: String):
    instance = instance_in
    method = method_in