extends Node
class_name TrustedPlatformClient

# URLs
const KOVAN_BASE = "kovan.cloud.enjin.io"
# Endpoints
const GRAPHQL = "/graphql"

var url: String
var http: EnjinHttp

func _init(base_url: String = KOVAN_BASE):
    url = base_url

func login_user(email: String, password: String, callback: EnjinCallback):
    var formatted_query = EnjinOauth.login_user_query(email, password)
    graphql_request(formatted_query, callback)

func graphql_request(query: String, callback: EnjinCallback):
    var call = EnjinCall.new()
    call.set_method(HTTPClient.METHOD_POST)
    call.set_endpoint(GRAPHQL)
    call.set_body(to_json_body(query))
    http.enqueue(call, callback)

func to_json_body(query: String) -> String:
    return to_json({"query": query})