extends "../BaseInput.gd"

const TokenFragmentInput = preload("res://addons/enjin/sdk/inputs/token/TokenFragmentInput.gd").TokenFragmentInput

var token_i: TokenFragmentInput

func _init():
    token_i = TokenFragmentInput.new(vars)
