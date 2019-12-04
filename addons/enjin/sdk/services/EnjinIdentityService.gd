extends Reference

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_identity(input: GetIdentityInput, udata: Dictionary = {}):
    _middleware.execute_gql("GetIdentityQuery", input.create(), udata)

func get_identities(input: GetIdentitiesInput, udata: Dictionary = {}):
    if udata.has("pagination"):
        _middleware.execute_gql("GetIdentitiesPaginatedQuery", input.create(), udata)
    else:
        _middleware.execute_gql("GetIdentitiesQuery", input.create(), udata)

func create_identity(input: CreateIdentityInput, udata: Dictionary = {}):
    _middleware.execute_gql("CreateIdentityMutation", input.create(), udata)

func update_identity(input: UpdateIdentityInput, udata: Dictionary = {}):
    _middleware.execute_gql("UpdateIdentityMutation", input.create(), udata)

func delete_identity(input: DeleteIdentityInput, udata: Dictionary = {}):
    _middleware.execute_gql("DeleteIdentityMutation", input.create(), udata)
