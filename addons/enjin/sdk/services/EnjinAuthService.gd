extends Reference

# auth types
const BEARER = "bearer"
# keys
const CALLBACK = "callback"
const TOKEN_TYPE = "token_type"
const ACCESS_TOKEN = "access_token"
const GQL_ACCESS_TOKENS = "accessTokens"
const GQL_ACCESS_TOKEN = "accessToken"

const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
const EnjinOauthQueries = preload("res://addons/enjin/sdk/queries/EnjinOauthQueries.gd")

var _state: TrustedPlatformState
var _middleware: TrustedPlatformMiddleware

func _init(state: TrustedPlatformState, middleware: TrustedPlatformMiddleware):
    _state = state
    _middleware = middleware

func auth_user(email: String, password: String, options: Dictionary = {}):
    _state.clear_auth()
    var body = EnjinOauthQueries.auth_user_query(email, password)
    # Create call
    var call = _middleware.graphql(body)
    var cb = EnjinCallback.new(self, "_auth_user_callback")
    # Enqueue Request
    _middleware._http.enqueue(call, cb, options)

func auth_app(app_id: int, secret: String, options: Dictionary = {}):
    _state.clear_auth()
    options.app_id = app_id
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
    _middleware._http.enqueue(call, cb, options)

func _auth_user_callback(res: EnjinResponse, options: Dictionary = {}):
    var out = {}
    out.response = res

    if res.has_body():
        var gql_res: EnjinGraphqlResponse = EnjinGraphqlResponse.new(res)
        out.gql = gql_res
        if gql_res.has_result():
            var access_token = gql_res.get_result()[GQL_ACCESS_TOKENS][0][GQL_ACCESS_TOKEN]
            _state.auth_user("%s %s" % [BEARER, access_token])

    if options.has(CALLBACK):
        var cb: EnjinCallback = options.get(CALLBACK)
        cb.complete_deffered_1(out)

func _auth_app_callback(res: EnjinResponse, options: Dictionary = {}):
    var out = {}
    out.response = res

    if res.has_body():
        var result: JSONParseResult = JSON.parse(res.get_body())
        if result.get_error() == OK:
            var data = result.get_result()
            out.json = data
            if data.has(TOKEN_TYPE) and data.has(ACCESS_TOKEN):
                _state.auth_app(options.app_id, "%s %s" % [data[TOKEN_TYPE], data[ACCESS_TOKEN]])

    if options.has(CALLBACK):
        var cb: EnjinCallback = options.get(CALLBACK)
        cb.complete_deferred_1(out)