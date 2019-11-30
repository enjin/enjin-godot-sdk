extends UserFragmentInput
class_name UpdateUserInput

func id(id: int) -> UpdateUserInput:
    vars.id = id
    return self

func name(name: String) -> UpdateUserInput:
    vars.name = name
    return self

func email(email: String) -> UpdateUserInput:
    vars.email = email
    return self

func password(password: String) -> UpdateUserInput:
    vars.password = password
    return self

func identity_id(identityId: int) -> UpdateUserInput:
    vars.identityId = identityId
    return self

func roles(roles: Array) -> UpdateUserInput:
    vars.roles = roles
    return self

func reset_password(resetPassword: bool) -> UpdateUserInput:
    vars.resetPassword = resetPassword
    return self

func reset_password_token(resetPasswordToken: String) -> UpdateUserInput:
    vars.resetPasswordToken = resetPasswordToken
    return self
