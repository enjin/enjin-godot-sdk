extends "../BaseInput.gd"

var role_i: EnjinSdkInputs.RoleFragmentInput
var identity_i: EnjinSdkInputs.IdentityFragmentInput
var wallet_i: EnjinSdkInputs.WalletFragmentInput
var balance_i: EnjinSdkInputs.BalanceFragmentInput
var token_i: EnjinSdkInputs.TokenFragmentInput

func _init():
    role_i = EnjinSdkInputs.RoleFragmentInput.new(vars)
    identity_i = EnjinSdkInputs.IdentityFragmentInput.new(vars)
    wallet_i = EnjinSdkInputs.WalletFragmentInput.new(vars)
    balance_i = EnjinSdkInputs.BalanceFragmentInput.new(vars)
    token_i = EnjinSdkInputs.TokenFragmentInput.new(vars)