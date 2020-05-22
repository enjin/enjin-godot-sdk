extends "./GetIdentityInput.gd"
class_name GetIdentitiesInput

const PaginatedInput = preload("res://addons/enjin/sdk/inputs/PaginatedInput.gd").PaginatedInput

var paginated_i: PaginatedInput

func _init():
    paginated_i = PaginatedInput.new(vars)

func app_id(appId: int) -> GetIdentitiesInput:
    vars.appId = appId
    return self

func eth_addr(ethAddr: String) -> GetIdentitiesInput:
    vars.ethAddr = ethAddr
    return self

func linking_code(linkingCode: String) -> GetIdentitiesInput:
    vars.linkingCode = linkingCode
    return self
