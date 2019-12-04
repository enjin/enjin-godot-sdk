extends "./BaseWalletInput.gd"
class_name UnlinkIdentityInput

func id(id: int) -> UnlinkIdentityInput:
    vars.id = id
    return self