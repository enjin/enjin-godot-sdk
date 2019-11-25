extends Reference
class_name TrustedPlatformClient

const TrustedPlatformState = preload("res://addons/enjin/sdk/TrustedPlatformState.gd")
const TrustedPlatformMiddleware = preload("res://addons/enjin/sdk/TrustedPlatformMiddleware.gd")
const EnjinHttp = preload("res://addons/enjin/sdk/http/EnjinHttp.gd")
const EnjinHosts = preload("res://addons/enjin/sdk/http/EnjinHosts.gd")
const EnjinAuthService = preload("res://addons/enjin/sdk/services/EnjinAuthService.gd")
const EnjinUserService = preload("res://addons/enjin/sdk/services/EnjinUserService.gd")
const EnjinGraphqlQueryBuilder = preload("res://addons/enjin/sdk/graphql/EnjinGraphqlQueryBuilder.gd")

var _base_url: String
var _http: EnjinHttp
var _state: TrustedPlatformState setget ,get_state
var _middleware: TrustedPlatformMiddleware
var _auth_service: EnjinAuthService setget ,auth_service
var _user_service: EnjinUserService setget ,user_service
var _query_builder: EnjinGraphqlQueryBuilder.GQLBuilder setget ,query_builder

func _init(base_url: String = EnjinHosts.KOVAN, port: int = 443, use_ssl: bool = true, verify_host: bool = true):
    _base_url = base_url
    _http = EnjinHttp.new(_base_url, port, use_ssl, verify_host)
    _state = TrustedPlatformState.new()
    
    _query_builder = EnjinGraphqlQueryBuilder.GQLBuilder.new()
    _query_builder.add_folder("res://addons/enjin/sdk/graphql/templates/")
    
    _middleware = TrustedPlatformMiddleware.new(_http, _state, _query_builder)
    _auth_service = EnjinAuthService.new(_state, _middleware)
    _user_service = EnjinUserService.new(_middleware)
    #TODO: scan default folder

func get_state() -> TrustedPlatformState:
    return _state

func auth_service() -> EnjinAuthService:
    return _auth_service

func user_service() -> EnjinUserService:
    return _user_service

func query_builder() -> EnjinGraphqlQueryBuilder.GQLBuilder:
    return _query_builder
