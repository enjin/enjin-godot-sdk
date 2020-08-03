extends BaseSchema
class_name Schema

const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")

func _init(middleware: TrustedPlatformMiddleware):
    super._init(middleware)
