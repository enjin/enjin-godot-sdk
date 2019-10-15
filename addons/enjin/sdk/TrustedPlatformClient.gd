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

var url: String
var http: EnjinHttp
var auth_app_id
var auth_token

func _init(base_url: String = KOVAN_BASE):
    url = base_url
    http = EnjinHttp.new(url)

func auth_user(email: String, password: String, callback: EnjinCallback):
    var body = EnjinOauth.auth_user_query(email, password)
    # Create call
    var call = graphql_request(body)
    # Create callback chain
    var cb = EnjinCallback.new(self, "auth_user_callback")
    cb.then(callback)
    # Enqueue Request
    http.enqueue(call, cb)

func auth_app(app_id: int, secret: String, callback: EnjinCallback):
    auth_app_id = app_id
    var body = {
        "grant_type": "client_credentials",
        "client_id": str(app_id),
        "client_secret": secret
    }
    # Create call
    var call = post(OAUTH_TOKEN, to_json(body))
    call.set_content_type(APPLICATION_JSON)
    # Create callback chain
    var cb = EnjinCallback.new(self, "auth_app_callback")
    cb.then(callback)
    # Enqueue Request
    http.enqueue(call, cb)

func auth_user_callback(res: EnjinResponse):
    if !res.is_success():
        clear_auth()
        return
    var gql_res: EnjinGraphqlResponse = EnjinGraphqlResponse.new(res)
    if !gql_res.is_success():
        clear_auth()
        return
    var access_token = gql_res.get_items()["accessTokens"][0]["accessToken"]
    auth_token = "%s %s" % [BEARER, access_token]

func auth_app_callback(res: EnjinResponse):
    if !res.is_success():
        clear_auth()
        return
    var result: JSONParseResult = JSON.parse(res.get_body())
    if result.get_error() != OK:
        clear_auth()
        return
    var data = result.get_result()
    auth_token = "%s %s" % [data[TOKEN_TYPE], data[ACCESS_TOKEN]]

func clear_auth():
    auth_app_id = null
    auth_token = null

func post(endpoint: String, body) -> EnjinCall:
    var call = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(endpoint)
    call.set_body(body)
    return call

func graphql_request(body):
    var call = post(GRAPHQL, to_json(body))
    call.set_content_type(APPLICATION_JSON)
    if auth_app_id != null:
        call.add_header(X_APP_ID, auth_app_id)
    if auth_token != null:
        call.add_header(AUTHORIZATION, auth_token)
    return call