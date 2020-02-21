extends "./BaseUserInput.gd"
class_name CreateUserInput

func name(name: String) -> CreateUserInput:
    vars.name = name
    return self
