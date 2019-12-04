extends "./BaseWalletInput.gd"
class_name UnlinkAppInput

func id(id: int) -> UnlinkAppInput:
    vars.id = id
    return self

func eth_addr(ethAddr: String) -> UnlinkAppInput:
    vars.ethAddr = ethAddr
    return self