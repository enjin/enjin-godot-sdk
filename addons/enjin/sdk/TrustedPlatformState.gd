extends Reference

var _auth_app_id
var _auth_token

func auth_user(token: String):
    _auth_token = token

func auth_app(app_id: int, token: String):
    _auth_app_id = app_id
    _auth_token = token

func clear_auth():
    _auth_app_id = null
    _auth_token = null

func is_authed() -> bool:
    return _auth_token != null