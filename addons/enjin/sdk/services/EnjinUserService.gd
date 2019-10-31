extends Reference

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
const EnjinGraphqlSchema = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlSchema.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_user(input: EnjinUserInput, options: Dictionary = {}):
    _middleware.submit_gql_request(EnjinGraphqlSchema.get_user(input), options)
