extends Reference
class_name TrustedPlatformClient

const Schema = preload("res://addons/enjin/sdk/schemas/Schema.gd")
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")

const KOVAN: String = "kovan.cloud.enjin.io"
const MAIN: String = "cloud.enjin.io"

var _middleware: TrustedPlatformMiddleware
var _schema: Schema
var _state: TrustedPlatformState setget ,get_state

func _init(base_url: String, debug: bool):
    _middleware = TrustedPlatformMiddleware.new(base_url, debug)
    _schema = Schema.new(_middleware)

func get_state() -> TrustedPlatformState:
    return _state
