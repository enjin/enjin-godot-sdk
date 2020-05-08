extends "../BaseInput.gd"

const WalletFragmentInput = preload("res://addons/enjin/sdk/inputs/wallet/WalletFragmentInput.gd").WalletFragmentInput
const BalanceFragmentInput = preload("res://addons/enjin/sdk/inputs/balance/BalanceFragmentInput.gd").BalanceFragmentInput
const TokenFragmentInput = preload("res://addons/enjin/sdk/inputs/token/TokenFragmentInput.gd").TokenFragmentInput

var wallet_i: WalletFragmentInput
var balance_i: BalanceFragmentInput
var token_i: TokenFragmentInput

func _init():
    wallet_i = WalletFragmentInput.new(vars)
    balance_i = BalanceFragmentInput.new(vars)
    token_i = TokenFragmentInput.new(vars)
