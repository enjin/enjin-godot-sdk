extends "./BaseIdentityInput.gd"
class_name DeleteIdentityInput

func id(id: int) -> DeleteIdentityInput:
    vars.id = id
    return self

func unlink(unlink: bool) -> DeleteIdentityInput:
    vars.unlink = unlink
    return self