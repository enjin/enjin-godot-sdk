extends Reference
class_name TrustedPlatformClient

# hosts
const KOVAN_BASE = "kovan.cloud.enjin.io"
# content types
const APPLICATION_JSON = "application/json"
# endpoints
const GRAPHQL = "/graphql"
const OAUTH_TOKEN = "/oauth/token"
# auth headers
const AUTHORIZATION = "Authorization"
const X_APP_ID = "X-App-Id"
# oauth/token body keys
const TOKEN_TYPE = "token_type"
const ACCESS_TOKEN = "access_token"
# auth types
const BEARER = "bearer"
# keys
const CALLBACK = "callback"
const GQL_ACCESS_TOKENS = "accessTokens"
const GQL_ACCESS_TOKEN = "accessToken"

var url: String
var http: EnjinHttp
var auth_app_id
var auth_token

func _init(base_url: String = KOVAN_BASE):
    url = base_url
    http = EnjinHttp.new(url)

func auth_user(email: String, password: String, options: Dictionary = {}):
    clear_auth()
    var body = EnjinOauth.auth_user_query(email, password)
    # Create call
    var call = _graphql_request(body)
    var cb = EnjinCallback.new(self, "_auth_user_callback")
    # Enqueue Request
    http.enqueue(call, cb, options)

func auth_app(app_id: int, secret: String, options: Dictionary = {}):
    clear_auth()
    options.app_id = app_id
    var body = {
        "grant_type": "client_credentials",
        "client_id": str(app_id),
        "client_secret": secret
    }
    # Create call
    var call = _post(OAUTH_TOKEN, to_json(body))
    call.set_content_type(APPLICATION_JSON)
    var cb = EnjinCallback.new(self, "_auth_app_callback")
    # Enqueue Request
    http.enqueue(call, cb, options)

func clear_auth():
    auth_app_id = null
    auth_token = null

func _auth_user_callback(res: EnjinResponse, options: Dictionary = {}):
    var out = {}
    out.response = res

    if res.has_body():
        var gql_res: EnjinGraphqlResponse = EnjinGraphqlResponse.new(res)
        out.gql = gql_res
        if gql_res.is_success():
            var access_token = gql_res.get_items()[GQL_ACCESS_TOKENS][0][GQL_ACCESS_TOKEN]
            auth_token = "%s %s" % [BEARER, access_token]

    if options.has(CALLBACK):
        var cb: EnjinCallback = options.get(CALLBACK)
        cb.complete_deferred_1(out)

func _auth_app_callback(res: EnjinResponse, options: Dictionary = {}):
    var out = {}
    out.response = res

    if res.has_body():
        var result: JSONParseResult = JSON.parse(res.get_body())
        if result.get_error() == OK:
            var data = result.get_result()
            out.json = data
            if data.has(TOKEN_TYPE) and data.has(ACCESS_TOKEN):
                auth_app_id = options.app_id
                auth_token = "%s %s" % [data[TOKEN_TYPE], data[ACCESS_TOKEN]]

    if options.has(CALLBACK):
        var cb: EnjinCallback = options.get(CALLBACK)
        cb.complete_deferred_1(out)

func _post(endpoint: String, body) -> EnjinCall:
    var call = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(endpoint)
    call.set_body(body)
    return call

func _graphql_request(body):
    var call = _post(GRAPHQL, to_json(body))
    call.set_content_type(APPLICATION_JSON)
    if auth_app_id != null:
        call.add_header(X_APP_ID, auth_app_id)
    if auth_token != null:
        call.add_header(AUTHORIZATION, auth_token)
    return call