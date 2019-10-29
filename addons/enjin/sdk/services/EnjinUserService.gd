extends Reference

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
const EnjinUserQueries = preload("res://addons/enjin/sdk/queries/EnjinUserQueries.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_user(input: EnjinUserInput, options: Dictionary = {}):
    _middleware.submit_gql_request(EnjinUserQueries.get_user(input), options)
