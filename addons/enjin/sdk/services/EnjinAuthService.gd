extends Reference

# auth types
const BEARER = "Bearer"
# keys
const CALLBACK = "callback"
const TOKEN_TYPE = "token_type"
const ACCESS_TOKEN = "access_token"
const GQL_ACCESS_TOKENS = "accessTokens"
const GQL_ACCESS_TOKEN = "accessToken"

const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
const EnjinEndpoints = preload("res://addons/enjin/sdk/http/EnjinEndpoints.gd")
const EnjinContentTypes = preload("res://addons/enjin/sdk/http/EnjinContentTypes.gd")
const EnjinOauthQueries = preload("res://addons/enjin/sdk/queries/EnjinOauthQueries.gd")

var _state: TrustedPlatformState
var _middleware: TrustedPlatformMiddleware
var _auth_user_cb: EnjinCallback

func _init(state: TrustedPlatformState, middleware: TrustedPlatformMiddleware):
    _state = state
    _middleware = middleware
    _auth_user_cb = EnjinCallback.new(self, "_auth_user_callback")

func auth_user(email: String, password: String, udata: Dictionary = {}):
    _state.clear_auth()
    var body = EnjinOauthQueries.auth_user_query(email, password)
    # Enqueue Request
    _middleware.submit_gql_request_cb(body, _auth_user_cb, udata)

func auth_app(app_id: int, secret: String, udata: Dictionary = {}):
    _state.clear_auth()
    udata.app_id = app_id
    var body = {
        "grant_type": "client_credentials",
        "client_id": str(app_id),
        "client_secret": secret
    }
    # Create call
    var call = _middleware.post(EnjinEndpoints.OAUTH_TOKEN, to_json(body))
    call.set_content_type(EnjinContentTypes.APPLICATION_JSON)
    var cb = EnjinCallback.new(self, "_auth_app_callback")
    # Enqueue Request
    _middleware._http.enqueue(call, cb, udata)

func _auth_user_callback(udata: Dictionary):
    _middleware.process_graphql_data(udata)
    var gql: EnjinGraphqlResponse = udata.gql
    var callback: EnjinCallback = udata.callback

    if gql != null and gql.has_result():
        var access_token = gql.get_result()[GQL_ACCESS_TOKENS][0][GQL_ACCESS_TOKEN]
        _state.auth_user("%s %s" % [BEARER, access_token])

    if callback != null:
        callback.complete_deffered_1(udata)

func _auth_app_callback(udata: Dictionary):
    var response: EnjinResponse = udata.response
    var callback: EnjinCallback = udata.callback

    if response.has_body():
        var result: JSONParseResult = JSON.parse(response.get_body())
        if result.get_error() == OK:
            var data = result.get_result()
            udata.json = data
            if data.has(TOKEN_TYPE) and data.has(ACCESS_TOKEN):
                _state.auth_app(udata.app_id, "%s %s" % [data[TOKEN_TYPE], data[ACCESS_TOKEN]])

    if callback != null:
        callback.complete_deferred_1(udata)