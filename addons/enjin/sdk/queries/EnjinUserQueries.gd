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
        id
    }
}
"""

static func get_user(input: EnjinUserInput):
    var body = {}
    body.query = GET_USER_QUERY
    body.variables = input.create()
    return body