extends Reference

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
#const EnjinGraphqlSchema = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlSchema.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_user(input: GetUserInput, options: Dictionary = {}):
    #_middleware.submit_gql_request(EnjinGraphqlSchema.get_user(input), options)
    _middleware.execute_gql_query("GetUserQuery", input.create(), options)

func get_users(input: GetUserInput, options: Dictionary = {}):
    _middleware.execute_gql_query("GetUsersQuery", input.create(), options)
    #_middleware.submit_gql_request(EnjinGraphqlSchema.get_users(input), options)

func create_user(input: CreateUserInput, options: Dictionary = {}):
    _middleware.execute_gql_query("CreateUserMutation", input.create(), options)
    #_middleware.submit_gql_request(EnjinGraphqlSchema.create_user(input), options)

func update_user(input: UpdateUserInput, options: Dictionary = {}):
    _middleware.execute_gql_query("UpdateUserMutation", input.create(), options)
    #_middleware.submit_gql_request(EnjinGraphqlSchema.update_user(input), options)

func delete_user(input: DeleteUserInput, options: Dictionary = {}):
    _middleware.execute_gql_query("DeleteUserMutation", input.create(), options)
    #_middleware.submit_gql_request(EnjinGraphqlSchema.delete_user(input), options)
