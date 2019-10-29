extends "res://addons/gut/test.gd"

const EnjinHttpServer = preload("res://addons/enjin/sdk/tests/EnjinHttpServer.gd")

const TrustedPlatformClient = preload("res://addons/enjin/sdk/TrustedPlatformClient.gd")
const EnjinCallback = preload("res://addons/enjin/sdk/http/EnjinCallback.gd")
const EnjinOauthQueries = preload("res://addons/enjin/sdk/queries/EnjinOauthQueries.gd")

var _cached_client: TrustedPlatformClient
var _trusted_client: TrustedPlatformClient

var _login_callback: EnjinCallback

var enjin_http_server = null
var doubled_class_instance = null

func before_all():
    enjin_http_server = EnjinHttpServer.new()
    enjin_http_server.Start()
    
    _cached_client = TrustedPlatformClient.new("127.0.0.1", 8080, false, false)
    _trusted_client = TrustedPlatformClient.new()
    
    var DoubledResponse = double(preload("res://addons/enjin/sdk/tests/double_response.gd"))
    doubled_class_instance = DoubledResponse.new()
    
    _login_callback = EnjinCallback.new(doubled_class_instance, "_on_callback_2")

func before_each():
    pass

func after_each():
    pass

func after_all():
    doubled_class_instance.free()
    enjin_http_server.free()

func test_TrustedPlatformClient():
    assert_not_null(_cached_client.get_state(), "TrustedPlatformClient._state is null.")
    assert_not_null(_cached_client.auth_service(), "TrustedPlatformClient._auth_service is null")
    assert_not_null(_cached_client.user_service(), "TrustedPlatformClient._user_service is null")

func test_TrustedPlatformClient_auth_user():
    var udata = {}
    udata.callback = _login_callback
    
    var password_input = get_tree().get_nodes_in_group("password_input")[0]
    var email_input = get_tree().get_nodes_in_group("email_input")[0]
    
    var username = email_input.text
    var password = password_input.text
    
    #Make sure passwords don't get leaked to cache by accident
    var sha256_username = username.sha256_text()
    var sha256_password = password.sha256_text()
    
    var auth_query_body = to_json(EnjinOauthQueries.auth_user_query(sha256_username, sha256_password))
    
    var use_cache = enjin_http_server.HasResponse(auth_query_body)
    if use_cache:
        _cached_client.auth_service().auth_user(sha256_username, sha256_password, udata)
        gut.p("CACHED Server")
    else:
        _trusted_client.auth_service().auth_user(username, password, udata)
        gut.p("Trusted Server")
    
    gut.simulate(enjin_http_server, 1000, 1)
    
    yield(yield_for(1), YIELD)
    
    assert_called(doubled_class_instance, "_on_callback_2")
    
    var params = get_call_parameters(doubled_class_instance, "_on_callback_2")
    
    var response : EnjinResponse = params[0].response
    
    assert_eq(response.has_body(), true, "Auth EnjinResponse has no body")
    
    if response.has_body():
        var body = response.get_body()

        var as_json = JSON.parse(body)
        
        if as_json.error == OK:
            var jsbody = as_json.result
            
            var tokens = jsbody.data.result.accessTokens
            
            for token in tokens:
                #Make sure token does not get leaked to cache by accident
                token.accessToken = token.accessToken.sha256_text()
        
            if not enjin_http_server.HasResponse(auth_query_body):
                enjin_http_server.SetResponse(auth_query_body, to_json(jsbody))
    
    #Check if authenticated
    var is_authed = false
    if use_cache:
        is_authed = _cached_client.get_state().is_authed()
    else:
        is_authed = _trusted_client.get_state().is_authed()
    
    assert_eq(is_authed, true, "Client not authenticated")
