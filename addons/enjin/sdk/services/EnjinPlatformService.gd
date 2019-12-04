extends Reference

const EMPTY_DICTIONARY: Dictionary = {}
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

var _middleware: TrustedPlatformMiddleware

func _init(middleware: TrustedPlatformMiddleware):
    _middleware = middleware

func get_platform(input: GetPlatformInput, udata: Dictionary = {}):
    _middleware.execute_gql("GetPlatformQuery", input.create(), udata)

func search(input: SearchInput, udata: Dictionary = {}):
    _middleware.execute_gql("SearchQuery", input.create(), udata)

func get_block_height(udata: Dictionary = {}):
    _middleware.execute_gql("GetBlockHeightQuery", EMPTY_DICTIONARY, udata)