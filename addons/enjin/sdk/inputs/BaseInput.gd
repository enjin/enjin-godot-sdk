extends Reference

var vars: Dictionary = {}

func _init(vars_in: Dictionary = {}):
    vars = vars_in

func create() -> Dictionary:
    return vars
