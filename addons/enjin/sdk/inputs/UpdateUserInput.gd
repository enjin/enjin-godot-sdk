extends UserFragmentInput
class_name UpdateUserInput

func id(id: int) -> UpdateUserInput:
    input.id = id
    return self

func name(name: String) -> UpdateUserInput:
    input.name = name
    return self

func email(email: String) -> UpdateUserInput:
    input.email = email
    return self

func password(password: String) -> UpdateUserInput:
    input.password = password
    return self

func identity_id(identity_id: int) -> UpdateUserInput:
    input.identityId = identity_id
    return self

func role(roles: Array) -> UpdateUserInput:
    input.roles = roles
    return self

func reset_password(reset_password: bool) -> UpdateUserInput:
    input.resetPassword = reset_password
    return self

func reset_password_token(reset_password_token: String) -> UpdateUserInput:
    input.resetPasswordToken = reset_password_token
    return self
