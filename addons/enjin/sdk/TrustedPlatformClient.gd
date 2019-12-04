extends Reference
class_name TrustedPlatformClient

const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
const EnjinHttp = preload("res://addons/enjin/sdk/http/EnjinHttp.gd")
const EnjinHosts = preload("res://addons/enjin/sdk/http/EnjinHosts.gd")
const EnjinAuthService = preload("res://addons/enjin/sdk/services/EnjinAuthService.gd")
const EnjinUserService = preload("res://addons/enjin/sdk/services/EnjinUserService.gd")
const EnjinIdentityService = preload("res://addons/enjin/sdk/services/EnjinIdentityService.gd")
const EnjinBalanceService = preload("res://addons/enjin/sdk/services/EnjinBalanceService.gd")
const EnjinRoleService = preload("res://addons/enjin/sdk/services/EnjinRoleService.gd")
const EnjinWalletService = preload("res://addons/enjin/sdk/services/EnjinWalletService.gd")
const EnjinTokenService = preload("res://addons/enjin/sdk/services/EnjinTokenService.gd")
const EnjinRequestService = preload("res://addons/enjin/sdk/services/EnjinRequestService.gd")

var _base_url: String
var _http: EnjinHttp
var _state: TrustedPlatformState setget ,get_state
var _middleware: TrustedPlatformMiddleware
var _auth_service: EnjinAuthService setget ,auth_service
var _user_service: EnjinUserService setget ,user_service
var _identity_service: EnjinIdentityService setget ,identity_service
var _balance_service: EnjinBalanceService setget, balance_service
var _role_service: EnjinRoleService setget, role_service
var _wallet_service: EnjinWalletService setget, wallet_service
var _token_service: EnjinTokenService setget, token_service
var _request_service: EnjinRequestService setget, request_service

func _init(base_url: String = EnjinHosts.KOVAN, port: int = 443, use_ssl: bool = true, verify_host: bool = true):
    _base_url = base_url
    _http = EnjinHttp.new(_base_url, port, use_ssl, verify_host)
    _state = TrustedPlatformState.new()

    _middleware = TrustedPlatformMiddleware.new(_http, _state)
    _auth_service = EnjinAuthService.new(_state, _middleware)
    _user_service = EnjinUserService.new(_middleware)
    _identity_service = EnjinIdentityService.new(_middleware)
    _balance_service = EnjinBalanceService.new(_middleware)
    _role_service = EnjinRoleService.new(_middleware)
    _wallet_service = EnjinWalletService.new(_middleware)
    _token_service = EnjinTokenService.new(_middleware)
    _request_service = EnjinRequestService.new(_middleware)

func get_state() -> TrustedPlatformState:
    return _state

func auth_service() -> EnjinAuthService:
    return _auth_service

func user_service() -> EnjinUserService:
    return _user_service

func identity_service() -> EnjinIdentityService:
    return _identity_service

func balance_service() -> EnjinBalanceService:
    return _balance_service

func role_service() -> EnjinRoleService:
    return _role_service

func wallet_service() -> EnjinWalletService:
    return _wallet_service

func token_service() -> EnjinTokenService:
    return _token_service

func request_service() -> EnjinRequestService:
    return _request_service