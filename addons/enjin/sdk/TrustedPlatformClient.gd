extends Reference

const Schema = preload("res://addons/enjin/sdk/schemas/Schema.gd")
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")

const KOVAN: String = "kovan.cloud.enjin.io"
const MAIN: String = "cloud.enjin.io"

var _middleware: TrustedPlatformMiddleware setget , get_middleware
var _schema: Schema setget , get_schema
var _state: TrustedPlatformState setget , get_state

func _init(base_url: String, debug: bool, schema: String):
    _state = TrustedPlatformState.new()
    _middleware = TrustedPlatformMiddleware.new(base_url, debug, schema, _state)
    _schema = Schema.new(_middleware)

func get_middleware() -> TrustedPlatformMiddleware:
    return _middleware

func get_schema() -> Schema:
    return _schema

func get_state() -> TrustedPlatformState:
    return _state
