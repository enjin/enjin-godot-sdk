extends "./BaseIdentityInput.gd"
class_name UpdateIdentityInput

func id(id: int) -> UpdateIdentityInput:
    vars.id = id
    return self

func linking_code(linkingCode: String) -> UpdateIdentityInput:
    vars.linkingCode = linkingCode
    return self

func eth_addr(ethAddr: String) -> UpdateIdentityInput:
    vars.ethAddr = ethAddr
    return self
