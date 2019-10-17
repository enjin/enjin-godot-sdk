extends Reference
class_name EnjinOauthQueries

const AUTH_USER_QUERY: String = """
query Login($email: String!,
            $password: String!)
{
    result: EnjinOauth(email: $email,
                       password: $password)
    {
        id,
        accessTokens
    }
}
"""

static func auth_user_query(var email: String, var password: String):
    var body = {
        "query": AUTH_USER_QUERY,
        "variables": {
            "email": email,
            "password": password
        }
    }
    return body