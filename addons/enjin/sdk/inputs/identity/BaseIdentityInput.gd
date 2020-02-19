extends "../BaseInput.gd"

const IdentityFragmentInput = preload("res://addons/enjin/sdk/inputs/identity/IdentityFragmentInput.gd").IdentityFragmentInput
const WalletFragmentInput = preload("res://addons/enjin/sdk/inputs/wallet/WalletFragmentInput.gd").WalletFragmentInput
const BalanceFragmentInput = preload("res://addons/enjin/sdk/inputs/balance/BalanceFragmentInput.gd").BalanceFragmentInput
const TokenFragmentInput = preload("res://addons/enjin/sdk/inputs/token/TokenFragmentInput.gd").TokenFragmentInput

var identity_i: IdentityFragmentInput
var wallet_i: WalletFragmentInput
var balance_i: BalanceFragmentInput
var token_i: TokenFragmentInput

func _init():
    identity_i = IdentityFragmentInput.new(vars)
    wallet_i = WalletFragmentInput.new(vars)
    balance_i = BalanceFragmentInput.new(vars)
    token_i = TokenFragmentInput.new(vars)