extends Node
class_name EnjinOauth

const LOGIN_USER_QUERY: String = """
query Login {
    result: EnjinOauth(email: \"{email}\", password: \"{pass}\") {
        id,
        accessTokens
    }
}
"""

static func login_user_query(var email: String, var password: String):
    var params = {
        "email": email,
        "pass": password
    }
    return LOGIN_USER_QUERY.format(params)