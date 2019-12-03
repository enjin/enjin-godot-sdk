extends "./BaseUserInput.gd"
class_name CreateUserInput

func app_id(appId: int) -> CreateUserInput:
    vars.appId = appId
    return self

func name(name: String) -> CreateUserInput:
    vars.name = name
    return self

func email(email: String) -> CreateUserInput:
    vars.email = email
    return self

func password(password: String) -> CreateUserInput:
    vars.password = password
    return self

func identity_id(identityId: int) -> CreateUserInput:
    vars.identityId = identityId
    return self

func role(role: String) -> CreateUserInput:
    vars.role = role
    return self