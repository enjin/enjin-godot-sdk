extends "./BaseWalletInput.gd"
class_name GetWalletInput

func eth_addr(ethAddr: String) -> GetWalletInput:
    vars.ethAddr = ethAddr
    return self
