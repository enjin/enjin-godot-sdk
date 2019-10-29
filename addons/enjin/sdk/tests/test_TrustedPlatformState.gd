extends "res://addons/gut/test.gd"

const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")

var token = "token"
var app_id = 201920192019

func before_all():
    pass

func before_each():
    pass

func after_each():
    pass

func after_all():
    pass

func test_TrustedPlatformState_auth_user():
    var state = TrustedPlatformState.new()
    state.auth_user(token)
    assert_not_null(state._auth_token, "Access token is not set")

func test_TrustedPlatformState_auth_app():
    var state = TrustedPlatformState.new()
    state.auth_app(app_id, token)
    assert_eq(state._auth_app_id, app_id, "AppID is not set")
    assert_eq(state._auth_token, token, "Access token is not set")

func test_TrustedPlatformState_clear_auth():
    var state = TrustedPlatformState.new()
    state.auth_app(app_id, token)
    assert_eq(state._auth_token, token, "Access token is not set")
    assert_eq(state._auth_app_id, app_id, "AppID is not set")
    state.clear_auth()
    assert_null(state._auth_token, "Access token should be empty")
    assert_null(state._auth_app_id, "AppID should be set to 0")
