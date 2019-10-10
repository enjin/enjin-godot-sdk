extends Object
class_name EnjinOauth

const LOGIN_USER_QUERY: String = """
query Login($app_id: Int,
            $email: String!,
            $password: String!)
{
    result: EnjinOauth(app_id: $app_id,
                       email: $email,
                       password: $password)
    {
        id,
        accessTokens
    }
}
"""

static func login_user_query(var email: String, var password: String):
    var body = {
        "query": LOGIN_USER_QUERY,
        "variables": {
            "email": email,
            "password": password
        }
    }
    return body