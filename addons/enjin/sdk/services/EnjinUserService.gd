extends Reference

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_user(input: GetUserInput, udata: Dictionary = {}):
    _middleware.execute_gql("GetUserQuery", input.create(), udata)

func get_users(input: GetUsersInput, udata: Dictionary = {}):
    if udata.has("pagination"):
        _middleware.execute_gql("GetUsersPaginatedQuery", input.create(), udata)
    else:
        _middleware.execute_gql("GetUsersQuery", input.create(), udata)

func create_user(name: String, udata: Dictionary = {}):
    var vars = {}
    vars.name = name
    _middleware.execute_gql("CreateUserMutation", vars, udata)
