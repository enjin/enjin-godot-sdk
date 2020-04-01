extends Reference

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_wallet(input: GetWalletInput, udata: Dictionary = {}):
    _middleware.execute_gql("GetWalletQuery", input.create(), udata)

func unlink_app(input: UnlinkAppInput, udata: Dictionary = {}):
    _middleware.execute_gql("UnlinkAppMutation", input.create(), udata)

func unlink_identity(input: UnlinkIdentityInput, udata: Dictionary = {}):
    _middleware.execute_gql("UnlinkIdentityMutation", input.create(), udata)
