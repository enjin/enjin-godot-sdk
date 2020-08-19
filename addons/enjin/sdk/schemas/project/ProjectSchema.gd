extends "res://addons/enjin/sdk/schemas/shared/SharedSchema.gd"

const SCHEMA: String = "app"

func _init(middleware: TrustedPlatformMiddleware).(middleware, SCHEMA):
    pass

func auth_player(request: AuthPlayer,
                 callback: EnjinCallback,
                 udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func auth_project(request: AuthProject,
                  callback: EnjinCallback,
                  udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func create_player(request: CreatePlayer,
                   callback: EnjinCallback,
                   udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func create_token(request: CreateToken,
                  callback: EnjinCallback,
                  udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func decrease_max_melt_fee(request: DecreaseMaxMeltFee,
                           callback: EnjinCallback,
                           udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func decrease_max_transfer_fee(request: DecreaseMaxTransferFee,
                               callback: EnjinCallback,
                               udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func delete_player(request: DeletePlayer,
                   callback: EnjinCallback,
                   udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func get_player(request: ProjectGetPlayer,
                callback: EnjinCallback,
                udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func get_players(request: GetPlayers,
                 callback: EnjinCallback,
                 udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func invalidate_token_metadata(request: InvalidateTokenMetadata,
                               callback: EnjinCallback,
                               udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func mint_token(request: MintToken,
                callback: EnjinCallback,
                udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func release_reserve(request: ReleaseReserve,
                     callback: EnjinCallback,
                     udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func set_melt_fee(request: SetMeltFee,
                  callback: EnjinCallback,
                  udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func set_transferable(request: SetTransferable,
                      callback: EnjinCallback,
                      udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func set_transfer_fee(request: SetTransferFee,
                      callback: EnjinCallback,
                      udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func set_uri(request: SetUri,
             callback: EnjinCallback,
             udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func set_whitelisted(request: SetWhitelisted,
                     callback: EnjinCallback,
                     udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func unlink_wallet(request: ProjectUnlinkWallet,
                   callback: EnjinCallback,
                   udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)

func update_name(request: UpdateName,
                 callback: EnjinCallback,
                 udata: Dictionary):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, callback, udata)
