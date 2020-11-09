extends "res://addons/enjin/sdk/schemas/player/PlayerSchema.gd"
class_name PlayerClient

const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")

func _init(base_url: String, debug: bool = false).(TrustedPlatformMiddleware.new(base_url, debug)):
    pass

func get_state() -> TrustedPlatformState:
    return _middleware.get_state()
