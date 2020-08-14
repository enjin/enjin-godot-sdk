extends "res://addons/enjin/sdk/schemas/shared/SharedSchema.gd"

const SCHEMA: String = "player"

func _init(middleware: TrustedPlatformMiddleware).(middleware, SCHEMA):
    pass

func get_player(request: PlayerGetPlayer,
                callback: EnjinCallback,
                udata: Dictionary):
    var call: EnjinCall = _http_service.post(SCHEMA, create_request_body(request))
    send_request(call, callback, udata)

func unlink_wallet(request: PlayerUnlinkWallet,
                   callback: EnjinCallback,
                   udata: Dictionary):
    pass
