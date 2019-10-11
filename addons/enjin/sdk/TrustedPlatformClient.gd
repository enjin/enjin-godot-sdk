extends Reference
class_name TrustedPlatformClient

# URLs
const KOVAN_BASE = "kovan.cloud.enjin.io"
# Content Types
const APPLICATION_JSON = "application/json"
# Endpoints
const GRAPHQL = "/graphql"
const OAUTH_TOKEN = "/oauth/token"

var url: String
var http: EnjinHttp

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
    pass

func auth_app_callback(res: EnjinResponse):
    pass

func post(endpoint: String, body) -> EnjinCall:
    var call = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(endpoint)
    call.set_body(body)
    return call

func graphql_request(body):
    var call = post(GRAPHQL, to_json(body))
    call.set_content_type(APPLICATION_JSON)
    return call