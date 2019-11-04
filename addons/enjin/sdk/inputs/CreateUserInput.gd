extends Reference
class_name CreateUserInput

var input: Dictionary = {}

func app_id(app_id: int) -> CreateUserInput:
    input.app_id = app_id
    return self

func name(name: String) -> CreateUserInput:
    input.name = name
    return self

func email(email: String) -> CreateUserInput:
    input.email = email
    return self

func password(password: String) -> CreateUserInput:
    input.password = password
    return self

func identity_id(identity_id: int) -> CreateUserInput:
    input.identity_id = identity_id
    return self

func role(role: String) -> CreateUserInput:
    input.role = role
    return self