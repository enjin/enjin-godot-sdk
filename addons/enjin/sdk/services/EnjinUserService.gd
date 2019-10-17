extends Reference
class_name EnjinUserService

var middleware: TrustedPlatformMiddleware

func _init(middleware_in: TrustedPlatformMiddleware):
    middleware = middleware_in