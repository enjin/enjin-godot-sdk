extends Reference

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
const EnjinGraphqlSchema = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlSchema.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_user(input: GetUserInput, options: Dictionary = {}):
    _middleware.submit_gql_request(EnjinGraphqlSchema.get_user(input), options)

func get_users(input: GetUserInput, options: Dictionary = {}):
    _middleware.submit_gql_request(EnjinGraphqlSchema.get_users(input), options)

func create_user(input: CreateUserInput, options: Dictionary = {}):
    _middleware.submit_gql_request(EnjinGraphqlSchema.create_user(input), options)
