extends "./BaseRequestInput.gd"
class_name GetRequestsInput

const PaginatedInput = preload("res://addons/enjin/sdk/inputs/PaginatedInput.gd").PaginatedInput

var paginated_i: PaginatedInput

func _init():
    paginated_i = PaginatedInput.new(vars)

func id(id: int) -> GetRequestsInput:
    vars.id = id
    return self

func tx_id(txId: String) -> GetRequestsInput:
    vars.txId = txId
    return self

func identity_id(identityId: int) -> GetRequestsInput:
    vars.identityId = identityId
    return self

func tx_type(txType: String) -> GetRequestsInput:
    vars.txType = txType
    return self

func recipient_id(recipientId: int) -> GetRequestsInput:
    vars.recipientId = recipientId
    return self

func recipient_addr(recipientAddr: String) -> GetRequestsInput:
    vars.recipientAddr = recipientAddr
    return self

func sender_or_recipient_id(senderOrRecipientId: int) -> GetRequestsInput:
    vars.senderOrRecipientId = senderOrRecipientId
    return self

func token_id(tokenId: String) -> GetRequestsInput:
    vars.tokenId = tokenId
    return self

func value(value: String) -> GetRequestsInput:
    vars.value = value
    return self

func tx_state_in(txStateIn: Array) -> GetRequestsInput:
    vars.txStateIn = txStateIn
    return self

func sort(sort: Dictionary) -> GetRequestsInput:
    vars.sort = sort
    return self

func broadcast_only(broadcastOnly: bool) -> GetRequestsInput:
    vars.broadcastOnly = broadcastOnly
    return self
