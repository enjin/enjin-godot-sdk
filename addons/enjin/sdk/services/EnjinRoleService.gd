extends Reference

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_roles(input: GetRolesInput, udata: Dictionary = {}):
    _middleware.execute_gql("GetUsersQuery", input.create(), udata)

func create_role(input: CreateRoleInput, udata: Dictionary = {}):
    _middleware.execute_gql("CreateUserMutation", input.create(), udata)

func update_role(input: UpdateRoleInput, udata: Dictionary = {}):
    _middleware.execute_gql("UpdateUserMutation", input.create(), udata)

func delete_role(input: DeleteRoleInput, udata: Dictionary = {}):
    _middleware.execute_gql("DeleteUserMutation", input.create(), udata)
