extends Reference

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_requests(input: GetRequestsInput, udata: Dictionary = {}):
    if udata.has("pagination"):
        _middleware.execute_gql("GetRequestsPaginatedQuery", input.create(), udata)
    else:
        _middleware.execute_gql("GetRequestsQuery", input.create(), udata)

func create_request(input: CreateRequestInput, udata: Dictionary = {}):
    _middleware.execute_gql("CreateRequestMutation", input.create(), udata)

func update_request(input: UpdateRequestInput, udata: Dictionary = {}):
    _middleware.execute_gql("UpdateRequestMutation", input.create(), udata)

func delete_request(input: DeleteRequestInput, udata: Dictionary = {}):
    _middleware.execute_gql("DeleteRequestMutation", input.create(), udata)
