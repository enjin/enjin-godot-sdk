extends Reference

var _auth_project_id = null
var _auth_token = null

func auth_user(token: String):
    _auth_token = "Bearer %s" % token

func auth_project(project_id: int, token: String):
    _auth_project_id = project_id
    _auth_token = token

func clear_auth():
    _auth_project_id = null
    _auth_token = null

func is_authed() -> bool:
    return _auth_token != null

func is_authed_as_project() -> bool:
    return _auth_project_id != null && _auth_token != null
