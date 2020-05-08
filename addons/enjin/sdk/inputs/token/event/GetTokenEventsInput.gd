extends "../../BaseInput.gd"
class_name GetTokenEventsInput

const TokenFragmentInput = preload("res://addons/enjin/sdk/inputs/token/TokenFragmentInput.gd").TokenFragmentInput
const TokenEventFragmentInput = preload("res://addons/enjin/sdk/inputs/token/event/TokenEventFragmentInput.gd").TokenEventFragmentInput
const PaginatedInput = preload("res://addons/enjin/sdk/inputs/PaginatedInput.gd").PaginatedInput

var token_i: TokenFragmentInput
var event_i: TokenEventFragmentInput
var paginated_i: PaginatedInput

func _init():
    token_i = TokenFragmentInput.new(vars)
    event_i = TokenEventFragmentInput.new(vars)
    paginated_i = PaginatedInput.new(vars)

func id(id: int) -> GetTokenEventsInput:
    vars.id = id
    return self

func token_id(tokenId: String) -> GetTokenEventsInput:
    vars.tokenId = tokenId
    return self

func type(eventType: String) -> GetTokenEventsInput:
    vars.eventType = eventType
    return self

func block_number(blockNumber: int) -> GetTokenEventsInput:
    vars.blockNumber = blockNumber
    return self
