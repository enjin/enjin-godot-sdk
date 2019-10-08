extends Node
class_name TrustedPlatformClient

# URLs
const KOVAN_BASE = "kovan.cloud.enjin.io"
# Content Types
const APPLICATION_JSON = "application/json"
# Endpoints
const GRAPHQL = "/graphql"

var url: String
var http: EnjinHttp

func _init(base_url: String = KOVAN_BASE):
    url = base_url
    http = EnjinHttp.new(url)

func login_user(email: String, password: String, callback: EnjinCallback):
    var body = EnjinOauth.login_user_query(email, password)
    graphql_request(body, callback)

func graphql_request(body, callback: EnjinCallback):
    var call = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(GRAPHQL)
    call.set_content_type(APPLICATION_JSON)
    call.set_body(to_json(body))
    http.enqueue(call, callback)