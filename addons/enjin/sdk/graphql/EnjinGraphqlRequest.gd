extends "res://addons/enjin/sdk/graphql/EnjinVariableHolder.gd"

var _namespace: String setget , get_namespace

func _init(namespace: String).():
    _namespace = namespace

func get_namespace() -> String:
    return _namespace
