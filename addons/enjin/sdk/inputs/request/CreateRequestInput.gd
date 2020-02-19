extends "./RequestDataInput.gd".RequestDataInput
class_name CreateRequestInput

func tx_type(txType: String) -> CreateRequestInput:
    vars.txType = txType
    return self

func app_id(appId: int) -> CreateRequestInput:
    vars.appId = appId
    return self

func eth_addr(ethAddr: String) -> CreateRequestInput:
    vars.ethAddr = ethAddr
    return self

func identity_id(identityId: int) -> CreateRequestInput:
    vars.identityId = identityId
    return self

func test(test: bool) -> CreateRequestInput:
    vars.test = test
    return self

func dummy(dummy: bool) -> CreateRequestInput:
    vars.dummy = dummy
    return self
