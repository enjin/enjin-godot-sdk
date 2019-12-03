extends "./BaseIdentityInput.gd"
class_name GetIdentityInput

func id(id: int) -> GetIdentityInput:
    vars.id = id
    return self

func unlink(unlink: bool) -> GetIdentityInput:
    vars.unlink = unlink
    return self