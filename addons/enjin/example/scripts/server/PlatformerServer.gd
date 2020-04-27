extends Node

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
        "coin": {
            "id": ""
        },
       "crown": {
           "id": ""
        },
        "key": {
            "id": ""
        },
        "health_upgrade": {
            "id": ""
        }
    }
}
const SETTINGS_FILE_NAME: String = "server.cfg"

var _settings: Settings
var _server: WebSocketServer
var _tp_client: TrustedPlatformClient
var _client_peer_id: int
var _client_name: String
var _auth_app_callback: EnjinCallback
var _auth_player_callback: EnjinCallback
var _create_player_callback: EnjinCallback
var _send_tokens_callback: EnjinCallback

func _init():
    _settings = Settings.new(DEFAULT_SETTINGS, SETTINGS_FILE_NAME)
    _server = WebSocketServer.new()
    _tp_client = TrustedPlatformClient.new()
    _auth_app_callback = EnjinCallback.new(self, "_auth_app")
    _auth_player_callback = EnjinCallback.new(self, "_auth_player")
    _create_player_callback = EnjinCallback.new(self, "_create_player")
    _send_tokens_callback = EnjinCallback.new(self, "_send_tokens")

    _settings.save()
    _settings.load()

    _server.connect("data_received", self, "_data_received")

func _ready():
    # Prevents web socket from being paused
    self.set_pause_mode(2)

    # Check if the settings have been configured.
    if !_settings_valid():
        # If not then quit.
        get_tree().quit()

    var settings = _settings.data()

    # Start the web socket server on the configured port.
    _server.listen(settings.connection.port)
    # Aunthenticate the cloud client using the app settings.
    _tp_client.auth_service().auth_app(settings.app.id, settings.app.secret, { "callback": _auth_app_callback })

func _exit_tree():
    # Stop the web socket server when this node is removed from the tree.
    _server.stop()

func _process(delta):
    # Check if the server has started listening for connections.
    if _server.is_listening():
        # If so poll for packets.
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

func _data_received(peer_id):
    # Check if the peer is connected.
    if !_server.has_peer(peer_id):
        print("peer not found: %s" % peer_id)
        return

    var peer = _server.get_peer(peer_id)
    var raw_packet = peer.get_packet()
    if not peer.was_string_packet():
        return
    # Decode the received packet.
    var packet = WebSocketHelper.decode_json(raw_packet)

    if packet.id == PacketIds.HANDSHAKE:
        auth_player(packet.name, peer_id)
    elif packet.id == PacketIds.SEND_TOKEN:
        send_tokens(packet.token, packet.amount, packet.recipient_wallet)

func auth_player(name: String, peer_id):
    # Check if the cloud client is authed.
    if !_tp_client.get_state().is_authed():
        _client_name = name
        _client_peer_id = peer_id
        return

    var udata = {
        "callback": _auth_player_callback,
        "peer_id": peer_id,
        "name": name
    }

    # Authenticate the player.
    _tp_client.auth_service().auth_player(name, udata)

func create_player(name, peer_id):
    var udata = {
        "callback": _create_player_callback,
        "peer_id": peer_id,
        "name": name
    }

    # Create the player account.
    _tp_client.user_service().create_user(name, udata)

func send_tokens(token: String, amount: int, recipient_wallet: String):
    var settings = _settings.data()
    var input = CreateRequestInput.new()
    var udata = { "callback": _send_tokens_callback }

    # Configure the create request input.
    input.app_id(settings.app.id)
    input.tx_type("SEND")
    input.identity_id(settings.developer.id)
    input.send_token({
            "token_id": token,
            "recipient_address": recipient_wallet,
            "value": amount
        })

    # Create a new request.
    _tp_client.request_service().create_request(input, udata)

func send_player_session(session, peer_id):
    # Create a packet with the player's session tokens, the app id and tokens.
    var packet = {
        "id": PacketIds.PLAYER_AUTH,
        "session": session,
        "app_id": _settings.data().app.id,
        "tokens": _settings.data().tokens
    }

    # Send the session data to the client.
    WebSocketHelper.send_packet(_server, packet, peer_id, WebSocketPeer.WRITE_MODE_TEXT)

func _auth_app(udata: Dictionary):
    # Quit if ap authentication failed.
    if !_tp_client.get_state().is_authed():
        print("Could not authenticate app %s" % _settings.data().app.id)
        get_tree().quit()

    # If the player connected before the app authenticated auth the player.
    if _client_peer_id:
        auth_player(_client_name, _client_peer_id)

func _auth_player(udata: Dictionary):
    var gql = udata.gql

    # Check for GraphQL errors.
    if gql.has_errors():
        print("Errors: %s" % PoolStringArray(udata.gql.get_errors()).join(","))
        if gql.get_errors()[0].code == 401:
            # Create a new player if the error code is 401.
            create_player(udata.name, udata.peer_id)
    elif gql.has_result():
        # Send the player's session data.
        send_player_session(gql.get_result(), udata.peer_id)

func _create_player(udata: Dictionary):
    var gql = udata.gql

    if gql.has_errors():
        print("Errors: %s" % PoolStringArray(udata.gql.get_errors()).join(","))
    elif gql.has_result():
        # Authenticate the player.
        auth_player(udata.name, udata.peer_id)

func _send_tokens(udata: Dictionary):
    if udata.gql.has_errors():
        print("Errors: %s" % PoolStringArray(udata.gql.get_errors()).join(","))
