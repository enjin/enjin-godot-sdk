extends Node

# Constants
const DEFAULT_SETTINGS: Dictionary = {
    "connection": {
        "port": 11011
    },
    "developer": {
        "id": 0
    },
    "app": {
        "id": 0,
        "secret": ""
    },
    "tokens": {
        "shard": {
            "id": ""
        },
       "crown": {
           "id": ""
        }
    }
}
const SETTINGS_FILE_NAME: String = "server.cfg"

# Fields
var _settings: Settings
var _server: WebSocketServer
var _clients: Dictionary
var _last_connected_client: int
var _tokens_collected: int
var _tp_client: TrustedPlatformClient
# Callbacks
var _auth_app_callback: EnjinCallback
var _auth_player_callback: EnjinCallback
var _create_player_callback: EnjinCallback
var _send_tokens_callback: EnjinCallback

func _init():
    _settings = Settings.new(DEFAULT_SETTINGS, SETTINGS_FILE_NAME)
    _server = WebSocketServer.new()
    _clients = {}
    _last_connected_client = 0
    _tokens_collected = 0
    _tp_client = TrustedPlatformClient.new()
    _auth_app_callback = EnjinCallback.new(self, "_auth_app")
    _auth_player_callback = EnjinCallback.new(self, "_auth_player")
    _create_player_callback = EnjinCallback.new(self, "_create_player")
    _send_tokens_callback = EnjinCallback.new(self, "_send_tokens")

    _settings.save()
    _settings.load()

    _server.connect("client_connected", self, "_client_connected")
    _server.connect("data_received", self, "_data_received")

func _ready():
    if !_settings_valid():
        get_tree().quit()

    _server.listen(_settings.data().connection.port)

    var settings = _settings.data()
    _tp_client.auth_service().auth_app(settings.app.id, settings.app.secret, { "callback": _auth_app_callback })

func _exit_tree():
    _clients.clear()
    _server.stop()

func _process(delta):
    if _server.is_listening():
        _server.poll()

func _settings_valid() -> bool:
    var settings = _settings.data()
    if settings.developer.id <= 0:
        return false
    if settings.app.id <= 0 or settings.app.secret.empty():
        return false
    for key in settings.tokens.keys():
        if settings.tokens[key].id.empty():
            return false
    return true

func _client_connected(id, protocol):
    _clients[id] = _server.get_peer(id)
    _last_connected_client = id
    print("%s: Client connected with protocol %s" % [id, protocol])

func _data_received(id):
    print("Data received from client %s" % id)
    if !_server.has_peer(id):
        return

    var peer = _server.get_peer(id)
    var packet = WebSocketHelper.decode(peer.get_packet(), peer.was_string_packet())
    if packet.id == PacketIds.HANDSHAKE:
        auth_player(packet.name, id)
    elif packet.id == PacketIds.SEND_TOKEN:
        send_tokens(packet.token, packet.amount, packet.player_id)

func auth_player(name: String, peer_id):
    var udata = {
        "callback": _auth_player_callback,
        "peer_id": peer_id,
        "name": name
    }
    _tp_client.auth_service().auth_player(name, udata)

func send_player_session(session, peer_id):
    var packet = {
        "id": PacketIds.PLAYER_AUTH,
        "session": session,
        "app_id": _settings.data().app.id,
        "tokens": _settings.data().tokens
    }
    WebSocketHelper.send_packet(_server, packet, peer_id)

func create_player(name, peer_id):
    var udata = {
        "callback": _create_player_callback,
        "name": name,
        "peer_id": peer_id
    }
    _tp_client.user_service().create_user(name, udata)

func send_tokens(name: String, amount: int, recipient_id: int):
    var settings = _settings.data()
    var input = CreateRequestInput.new()
    var udata = { "callback": _send_tokens_callback }

    input.app_id(settings.app.id)
    input.tx_type("SEND")
    input.identity_id(settings.developer.id)
    input.send_token({
            "token_id": settings.tokens[name].id,
            "recipient_identity_id": recipient_id,
            "value": amount
        })

    _tp_client.request_service().create_request(input, udata)

# Callbacks

func _auth_app(udata: Dictionary):
    if !_tp_client.get_state().is_authed():
        print("Could not authenticate app %s" % _settings.data().app.id)
        get_tree().quit()

func _auth_player(udata: Dictionary):
    var gql = udata.gql
    if gql.has_errors():
        print("Errors: %s" % PoolStringArray(udata.gql.get_errors()).join(","))
        if gql.get_errors()[0].code == 401:
            create_player(udata.name, udata.peer_id)
    elif gql.has_result():
        send_player_session(gql.get_result(), udata.peer_id)

func _create_player(udata: Dictionary):
    var gql = udata.gql
    if gql.has_errors():
        print("Errors: %s" % PoolStringArray(udata.gql.get_errors()).join(","))
        if gql.get_errors()[1].code == 401:
            create_player(udata.name, udata.peer_id)
    elif gql.has_result():
        auth_player(udata.name, udata.peer_id)

func _send_tokens(udata: Dictionary):
    if udata.gql.has_errors():
        print("Errors: %s" % PoolStringArray(udata.gql.get_errors()).join(","))
