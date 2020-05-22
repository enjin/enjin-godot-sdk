extends Reference

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_balances(input: GetBalancesInput, udata: Dictionary = {}):
    if udata.has("pagination"):
        _middleware.execute_gql("GetBalancesPaginatedQuery", input.create(), udata)
    else:
        _middleware.execute_gql("GetBalancesQuery", input.create(), udata)
