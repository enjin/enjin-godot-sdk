extends Reference

const GET_USER_QUERY: String = """
query GetUser($id: Int,
              $name: String,
              $me: Boolean = true)
{
    result: EnjinUser(id: $id,
                      name: $name,
                      me: $me)
    {
        ...UserFields
    }
}

fragment UserFields on EnjinUser {
    id
}
"""

static func get_user(input: EnjinUserInput):
    var body = {}
    body.query = GET_USER_QUERY
    body.operationName = "GetUser"
    body.variables = input.create()
    return body