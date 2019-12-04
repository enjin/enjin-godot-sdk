extends Reference

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_app(input: GetAppInput, udata: Dictionary = {}):
    _middleware.execute_gql("GetAppQuery", input.create(), udata)

func get_apps(input: GetAppsInput, udata: Dictionary = {}):
    if udata.has("pagination"):
        _middleware.execute_gql("GetAppsPaginatedQuery", input.create(), udata)
    else:
        _middleware.execute_gql("GetAppsQuery", input.create(), udata)

func create_app(input: CreateAppInput, udata: Dictionary = {}):
    _middleware.execute_gql("CreateAppMutation", input.create(), udata)

func update_app(input: UpdateAppInput, udata: Dictionary = {}):
    _middleware.execute_gql("UpdateAppMutation", input.create(), udata)

func delete_app(input: DeleteAppInput, udata: Dictionary = {}):
    _middleware.execute_gql("DeleteAppMutation", input.create(), udata)
