extends "./BaseIdentityInput.gd"
class_name UpdateIdentityInput

func id(id: int) -> UpdateIdentityInput:
    vars.id = id
    return self

func app_id(appId: int) -> UpdateIdentityInput:
    vars.appId = appId
    return self

func linking_code(linkingCode: String) -> UpdateIdentityInput:
    vars.linkingCode = linkingCode
    return self

func user_id(userId: int) -> UpdateIdentityInput:
    vars.userId = userId
    return self

func eth_addr(ethAddr: String) -> UpdateIdentityInput:
    vars.ethAddr = ethAddr
    return self
