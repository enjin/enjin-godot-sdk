extends Reference
class_name DeleteUserInput

var input: Dictionary = {}

func id(id: int) -> DeleteUserInput:
    input.id = id
    return self

func create() -> Dictionary:
    return input