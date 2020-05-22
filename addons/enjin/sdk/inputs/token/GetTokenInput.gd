extends "./BaseTokenInput.gd"
class_name GetTokenInput

func id(id: String) -> GetTokenInput:
    vars.id = id
    return self

func app_id(appId: int) -> GetTokenInput:
    vars.appId = appId
    return self
