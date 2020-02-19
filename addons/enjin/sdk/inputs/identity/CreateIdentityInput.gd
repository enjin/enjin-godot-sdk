extends "./BaseIdentityInput.gd"
class_name CreateIdentityInput

func app_id(appId: int) -> CreateIdentityInput:
    vars.appId = appId
    return self

func user_id(userId: int) -> CreateIdentityInput:
    vars.userId = userId
    return self

func email(email: String) -> CreateIdentityInput:
    vars.email = email
    return self

func eth_addr(ethAddr: String) -> CreateIdentityInput:
    vars.ethAddr = ethAddr
    return self
