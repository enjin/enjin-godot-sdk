extends "EnjinGraphqlQueryBuilder.gd"


static func auth_user_query(var email: String, var password: String):
    var vars = {}
    vars.email = email
    vars.password = password
    
    var auth_user_query = BuildQuery("LoginUserQuery")
    return create_body(auth_user_query, vars, "Login")

static func get_user(input: GetUserInput):
    var get_user_query = BuildQuery("GetUserQuery")
    return create_body(get_user_query, input.create(), "GetUser")

static func get_users(input: GetUserInput):
    var vars = input.create()
    var query = "" 
    if vars.pagination:
        query = BuildQuery("GetUsersPaginatedQuery")
    else:
        query = BuildQuery("GetUserQuery")
    return create_body(query, vars, "GetUsers")

static func create_user(input: CreateUserInput):
    var create_user_mutation = BuildQuery("CreateUserMutation")
    return create_body(create_user_mutation, input.create(), "CreateUser")

static func update_user(input: UpdateUserInput):
    var update_user_mutation = BuildQuery("UpdateUserMutation")
    return create_body(update_user_mutation, input.create(), "UpdateUser")

static func delete_user(input: DeleteUserInput):
    var delete_user_mutation = BuildQuery("DeleteUserMutation")
    return create_body(delete_user_mutation, input.create(), "CreateUser")

static func create_body(query: String, variables: Dictionary, operationName: String):
    var body = {}
    body.query = query
    body.variables = variables
    body.operationName = operationName
    return body
