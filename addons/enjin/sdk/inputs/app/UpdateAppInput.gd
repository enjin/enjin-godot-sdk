extends "./BaseAppInput.gd"
class_name UpdateAppInput

func id(id: int) -> UpdateAppInput:
    vars.id = id
    return self

func name(name: String) -> UpdateAppInput:
    vars.name = name
    return self

func description(description: String) -> UpdateAppInput:
    vars.description = description
    return self

func image(image: String) -> UpdateAppInput:
    vars.image = image
    return self

func generate_new_secret(generateNewSecret: bool) -> UpdateAppInput:
    vars.generateNewSecret = generateNewSecret
    return self

func revoke_secret(revokeSecret: bool) -> UpdateAppInput:
    vars.revokeSecret = revokeSecret
    return self

func invite_user(inviteUserInput: Dictionary) -> UpdateAppInput:
    vars.inviteUserInput = inviteUserInput
    return self