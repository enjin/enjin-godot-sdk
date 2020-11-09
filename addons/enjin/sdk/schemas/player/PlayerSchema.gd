extends "res://addons/enjin/sdk/schemas/shared/SharedSchema.gd"

const SCHEMA: String = "player"

func _init(middleware: TrustedPlatformMiddleware).(middleware, SCHEMA):
    pass

func get_player(request: PlayerGetPlayer,
                callback: EnjinCallback = null,
                udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func get_wallet(request: PlayerGetWallet,
                callback: EnjinCallback = null,
                udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)

func unlink_wallet(request: PlayerUnlinkWallet,
                   callback: EnjinCallback = null,
                   udata: Dictionary = {}):
    var call: EnjinCall = _middleware.post(_schema, create_request_body(request))
    send_request(call, udata, callback)
