extends "./GetIdentityInput.gd"
class_name GetIdentitiesInput

var paginated_i: EnjinSdkInputs.PaginatedInput

func _init():
    paginated_i = EnjinSdkInputs.PaginatedInput.new(vars)

func app_id(appId: int) -> GetIdentitiesInput:
    vars.appId = appId
    return self

func eth_addr(ethAddr: String) -> GetIdentitiesInput:
    vars.ethAddr = ethAddr
    return self

func linking_code(linkingCode: String) -> GetIdentitiesInput:
    vars.linkingCode = linkingCode
    return self