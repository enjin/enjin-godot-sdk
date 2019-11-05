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
    var vars = {}
    vars.email = email
    vars.password = password
    return create_body(AUTH_USER_QUERY, vars, "Login")

static func get_user(input: GetUserInput):
    return create_body(GET_USER_QUERY, input.create(), "GetUser")

static func get_users(input: GetUserInput):
    var vars = input.create()
    var query = GET_USERS_QUERY
    if vars.pagination != null:
        query = GET_USERS_PAGINATED_QUERY
    return create_body(query, vars, "GetUsers")

static func create_user(input: CreateUserInput):
    return create_body(CREATE_USER_MUTATION, input.create(), "CreateUser")

static func update_user(input: UpdateUserInput):
    return create_body(UPDATE_USER_MUTATION, input.create(), "UpdateUser")

static func delete_user(input: DeleteUserInput):
    return create_body(DELETE_USER_MUTATION, input.create(), "CreateUser")

static func create_body(query: String, variables: Dictionary, operationName: String):
    var body = {}
    body.query = query
    body.variables = variables
    body.operationName = operationName
    return body