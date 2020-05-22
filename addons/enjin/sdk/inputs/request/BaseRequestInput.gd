extends "../BaseInput.gd"

const TokenFragmentInput = preload("res://addons/enjin/sdk/inputs/token/TokenFragmentInput.gd").TokenFragmentInput
const TransactionFragmentInput = preload("res://addons/enjin/sdk/inputs/request/TransactionFragmentInput.gd").TransactionFragmentInput

var token_i: TokenFragmentInput
var transaction_i: TransactionFragmentInput

func _init():
    token_i = TokenFragmentInput.new(vars)
    transaction_i = TransactionFragmentInput.new(vars)
