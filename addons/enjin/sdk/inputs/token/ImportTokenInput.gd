extends "./BaseTokenInput.gd"
class_name ImportTokenInput

func id(id: String) -> ImportTokenInput:
    vars.id = id
    return self

func app_id(appId: int) -> ImportTokenInput:
    vars.appId = appId
    return self