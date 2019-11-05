extends Reference

# Fragment Definitions
const PAGINATION_CURSOR_FRAGMENT: String = """
fragment PaginationCursorFragment on PaginationCursor {
    total
    perPage
    currentPage
    hasPages
    from
    to
    lastPage
    hasMorePages
}
"""
const PERMISSION_FRAGMENT: String = """
fragment PermissionFragment on EnjinPermission {
    id
    name
}
"""
const ROLE_FRAGMENT: String = """
fragment RoleFragment on EnjinRole {
    id
    name
    appId
    permissions {
        ...PermissionFragment
    }
}
""" + PERMISSION_FRAGMENT
const SIMPLE_BALANCE_FRAGMENT: String = """
fragment SimpleBalanceFragment on EnjinBalance {
    id(format: $tokenIdFormat)
    index(format: $tokenIndexFormat)
    value
}
"""
const SIMPLE_TOKEN_FRAGMENT: String = """
fragment SimpleTokenFragment on EnjinToken {
    id(format: $tokenIndexFormat)
    name
    appId
    createdAt @include(if: $withTimestamps)
    updatedAt @include(if: $withTimestamps)
}
"""
const WALLET_FRAGMENT: String = """
fragment WalletFragment on EnjinWallet {
    ethAddress
    ethBalance
    enjBalance
    enjAllowance
    balances(
        appId: $balAppId,
        tokenId: $balTokenId,
        value: $balVal,
        value_gt: $balGt,
        value_gte: $balGte,
        value_lt: $balLt,
        value_lte: $balLte
    ) @include(if: $withBalances) {
        ...SimpleBalanceFragment
    }
    tokensCreated @include(if: $withTokensCreated) {
        ...SimpleTokenFragment
    }
}
""" + SIMPLE_BALANCE_FRAGMENT + SIMPLE_TOKEN_FRAGMENT
const IDENTITY_FRAGMENT: String = """
fragment IdentityFragment on EnjinIdentity {
    id
    appId
    linkingCode
    linkingCodeQr
    roles @include(if: $withIdentityRoles) {
        ...RoleFragment
    }
    wallet @include(if: $withWallet) {
        ...WalletFragment
    }
    createdAt @include(if: $withTimestamps)
    updatedAt @include(if: $withTimestamps)
}
""" + WALLET_FRAGMENT + ROLE_FRAGMENT
const USER_FRAGMENT: String = """
fragment UserFragment on EnjinUser {
    id
    name
    email
    roles @include(if: $withUserRoles) {
        ...RoleFragment
    }
    identities @include(if: $withIdentities) {
        ...IdentityFragment
    }
    createdAt @include(if: $withTimestamps)
    updatedAt @include(if: $withTimestamps)
}
""" + IDENTITY_FRAGMENT

# Arguments
const USER_FRAGMENT_ARGS = """$withUserRoles: Boolean = false,
$withIdentities: Boolean = false,
$withIdentityRoles: Boolean = false,
$withWallet: Boolean = false
$withBalances: Boolean = true,
$withTokensCreated: Boolean = false,
$withTimestamps: Boolean = false,
$balAppId: Int,
$balTokenId: String,
$balVal: Int,
$balGt: Int,
$balGte: Int,
$balLt: Int
$balLte: Int,
$tokenIdFormat: TokenIdFormat,
$tokenIndexFormat: TokenIndexFormat"""
const GET_USER_ARGS = """%s,
$id: Int,
$name: String,
$me: Boolean = true""" % USER_FRAGMENT_ARGS

# Query and Mutation Definitions
const AUTH_USER_QUERY: String = """
query Login(
$email: String!,
$password: String!
) {
    result: EnjinOauth(
        email: $email,
        password: $password
    ) {
        id,
        accessTokens
    }
}
"""
const GET_USER_QUERY: String = """
query GetUser(
%s
) {
    result: EnjinUser(
        id: $id,
        name: $name,
        me: $me
    ) {
        ...UserFragment
    }
}
""" % GET_USER_ARGS + USER_FRAGMENT
const GET_USERS_QUERY: String = """
query GetUsers(
%s
) {
    result: EnjinUsers(
        id: $id,
        name: $name,
        me: $me
    ) {
        ...UserFragment
    }
}
""" % GET_USER_ARGS + USER_FRAGMENT
const GET_USERS_PAGINATED_QUERY: String = """
query GetUsers(
%s,
$pagination: PaginationInput!
) {
    result: EnjinUsers(
        id: $id,
        name: $name,
        me: $me,
        pagination: $pagination
    ) {
        items {
            ...UserFragment
        }
        cursor {
            ...PaginationCursorFragment
        }
    }
}
""" % GET_USER_ARGS + USER_FRAGMENT + PAGINATION_CURSOR_FRAGMENT
const CREATE_USER_MUTATION: String = """
mutation CreateUser(
%s,
$app_id: Int,
$name: String!,
$email: String,
$password: String,
$identity_id: Int,
$role: String
) {
    result: CreateEnjinUser(
        app_id: $app_id,
        name: $name,
        email: $email,
        password: $password,
        identity_id: $identity_id,
        role: $role
    ) {
        ...UserFragment
    }
}
""" % USER_FRAGMENT_ARGS + USER_FRAGMENT
const UPDATE_USER_MUTATION: String = """
mutation UpdateUser(
%s,
$id: Int,
$name: String,
$email: String,
$password: String,
$identity_id: Int,
$roles: [String],
$reset_password: Boolean,
$reset_password_token: String
) {
    result: UpdateEnjinUser(
        id: $id,
        name: $name,
        email: $email,
        password: $password,
        identity_id: $identity_id,
        roles: $roles,
        reset_password: $reset_password,
        reset_password_token: $reset_password_token
    ) {
        ...UserFragment
    }
}
""" % USER_FRAGMENT_ARGS + USER_FRAGMENT
const DELETE_USER_MUTATION: String = """
mutation DeleteUser(
%s,
$id: Int
) {
    result: DeleteEnjinUser(
        id: $id
    ) {
        ...UserFragment
    }
}
""" % USER_FRAGMENT_ARGS + USER_FRAGMENT

static func auth_user_query(var email: String, var password: String):
    print(GET_USER_QUERY)
    var body = {}
    var variables = {}
    body.query = AUTH_USER_QUERY
    body.variables = variables
    variables.email = email
    variables.password = password
    return body

static func get_user(input: GetUserInput):
    var body = {}
    body.query = GET_USER_QUERY
    body.operationName = "GetUser"
    body.variables = input.create()
    return body

static func get_users(input: GetUserInput):
    var body = {}
    body.operationName = "GetUsers"
    body.variables = input.create()
    if body.variables.pagination == null:
        body.query = GET_USERS_QUERY
    else:
        body.query = GET_USERS_PAGINATED_QUERY
    return body

static func create_user(input: CreateUserInput):
    var body = {}
    body.operationName = "CreateUser"
    body.variables = input.create()
    body.query = CREATE_USER_MUTATION
    return body

static func update_user(input: UpdateUserInput):
    var body = {}
    body.operationName = "UpdateUser"
    body.variables = input.create()
    body.query = UPDATE_USER_MUTATION
    return body

static func delete_user(input: DeleteUserInput):
    var body = {}
    body.operationName = "DeleteUser"
    body.variables = input.create()
    body.query = DELETE_USER_MUTATION
    return body