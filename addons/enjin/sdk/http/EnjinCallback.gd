extends Node
class_name EnjinCallback

var instance: Object
var method: String

func _init(instance_in: Object, method_in: String):
    instance = instance_in
    method = method_in