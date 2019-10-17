extends Reference
class_name TrustedPlatformState

var auth_app_id
var auth_token

func auth_user(token: String):
    auth_token = token

func auth_app(app_id: int, token: String):
    auth_app_id = app_id
    auth_token = token

func clear_auth():
    auth_app_id = null
    auth_token = null

func is_authed() -> bool:
    return auth_token != null