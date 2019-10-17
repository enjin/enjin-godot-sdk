extends Reference

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
    var body = {}
    var variables = {}
    body.query = AUTH_USER_QUERY
    body.variables = variables
    variables.email = email
    variables.password = password
    return body