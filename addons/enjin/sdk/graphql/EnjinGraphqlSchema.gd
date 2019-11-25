extends "EnjinGraphqlQueryBuilder.gd"


static func auth_user_query(var email: String, var password: String):
    var vars = {}
    vars.email = email
    vars.password = password
    
    return _middleware.build_query_request("LoginUserQuery", vars, "LoginUserQuery")

static func get_user(input: GetUserInput):
    var get_user_query = build_query("GetUserQuery")
    return create_body(get_user_query, input.create(), "GetUser")

static func get_users(input: GetUserInput):
    var vars = input.create()
    var query = "" 
    if vars.pagination:
        query = build_query("GetUsersPaginatedQuery")
    else:
        query = build_query("GetUserQuery")
    return create_body(query, vars, "GetUsers")

static func create_user(input: CreateUserInput):
    var create_user_mutation = build_query("CreateUserMutation")
    return create_body(create_user_mutation, input.create(), "CreateUser")

static func update_user(input: UpdateUserInput):
    var update_user_mutation = build_query("UpdateUserMutation")
    return create_body(update_user_mutation, input.create(), "UpdateUser")

static func delete_user(input: DeleteUserInput):
    var delete_user_mutation = build_query("DeleteUserMutation")
    return create_body(delete_user_mutation, input.create(), "CreateUser")

static func create_body(query: String, variables: Dictionary, operationName: String):
    var body = {}
    body.query = query
    body.variables = variables
    body.operationName = operationName
    return body
