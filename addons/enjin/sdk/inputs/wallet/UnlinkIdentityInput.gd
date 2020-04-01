extends "../identity/BaseIdentityInput.gd"
class_name UnlinkIdentityInput

func id(id: int) -> UnlinkIdentityInput:
    vars.id = id
    return self

func eth_addr(ethAddr: String) -> UnlinkIdentityInput:
    vars.ethAddr = ethAddr
    return self
