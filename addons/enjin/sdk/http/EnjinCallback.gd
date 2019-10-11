extends Reference
class_name EnjinCallback

var instance: Object setget ,get_instance
var method: String setget ,get_method
var chained_callback: EnjinCallback setget ,get_chained_callbacks

func _init(instance_in: Object, method_in: String):
    instance = instance_in
    method = method_in

func get_instance() -> Object:
    return instance

func get_method() -> String:
    return method

func get_chained_callbacks() -> EnjinCallback:
    return chained_callback

func then(next: EnjinCallback):
    if next != null:
        chained_callback = next

func complete_deffered(data):
    instance.call_deferred(method, data)
    if chained_callback != null:
        chained_callback.complete_deffered(data)