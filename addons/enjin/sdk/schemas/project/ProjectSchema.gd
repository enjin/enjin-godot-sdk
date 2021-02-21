extends "res://addons/enjin/sdk/schemas/shared/SharedSchema.gd"

const SCHEMA: String = "app"

func _init(middleware: TrustedPlatformMiddleware).(middleware, SCHEMA):
    pass

func auth_player(request: AuthPlayer,
                 callback: EnjinCallback = null,
                 udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func auth_project(request: AuthProject,
                  callback: EnjinCallback = null,
                  udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func create_player(request: CreatePlayer,
                   callback: EnjinCallback = null,
                   udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func create_asset(request: CreateAsset,
                  callback: EnjinCallback = null,
                  udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func decrease_max_melt_fee(request: DecreaseMaxMeltFee,
                           callback: EnjinCallback = null,
                           udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func decrease_max_transfer_fee(request: DecreaseMaxTransferFee,
                               callback: EnjinCallback = null,
                               udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func delete_player(request: DeletePlayer,
                   callback: EnjinCallback = null,
                   udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_player(request: ProjectGetPlayer,
                callback: EnjinCallback = null,
                udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_players(request: GetPlayers,
                 callback: EnjinCallback = null,
                 udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_wallet(request: ProjectGetWallet,
                callback: EnjinCallback = null,
                udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_wallets(request: GetWallets,
                 callback: EnjinCallback = null,
                 udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func invalidate_asset_metadata(request: InvalidateAssetMetadata,
                               callback: EnjinCallback = null,
                               udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func mint_asset(request: MintAsset,
                callback: EnjinCallback = null,
                udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func release_reserve(request: ReleaseReserve,
                     callback: EnjinCallback = null,
                     udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func set_melt_fee(request: SetMeltFee,
                  callback: EnjinCallback = null,
                  udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func set_transferable(request: SetTransferable,
                      callback: EnjinCallback = null,
                      udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func set_transfer_fee(request: SetTransferFee,
                      callback: EnjinCallback = null,
                      udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func set_uri(request: SetUri,
             callback: EnjinCallback = null,
             udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func set_whitelisted(request: SetWhitelisted,
                     callback: EnjinCallback = null,
                     udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func unlink_wallet(request: ProjectUnlinkWallet,
                   callback: EnjinCallback = null,
                   udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)
