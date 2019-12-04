extends "./BaseTokenInput.gd"
class_name UpdateTokenInput

func id(id: String) -> UpdateTokenInput:
    vars.id = id
    return self

func app_id(appId: int) -> UpdateTokenInput:
    vars.appId = appId
    return self

func from_blockchain(fromBlockchain: bool) -> UpdateTokenInput:
    vars.fromBlockchain = fromBlockchain
    return self