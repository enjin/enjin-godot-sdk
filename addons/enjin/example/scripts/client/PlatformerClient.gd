extends Node2D

# Constants
const DEFAULT_SETTINGS: Dictionary = {
    "connection": {
        "port": 11011
    },
    "player": {
        "name": "DemoPlayer"
    }
}
const SETTINGS_FILE_NAME: String = "client.cfg"

# Fields
var player
var _settings: Settings
var _client: WebSocketClient
var _tp_client: TrustedPlatformClient
var _app_id: int
var _tokens
var _identity: Dictionary

# Callbacks
var _fetch_player_data_callback: EnjinCallback

func _init():
    _settings = Settings.new(DEFAULT_SETTINGS, SETTINGS_FILE_NAME)
    _client = WebSocketClient.new()
    _tp_client = TrustedPlatformClient.new()
    _app_id = 0
    _fetch_player_data_callback = EnjinCallback.new(self, "_fetch_player_data")

    _settings.save()
    _settings.load()

    _client.connect("connection_established", self, "_connection_established")
    _client.connect("connection_error", self, "_connection_error")
    _client.connect("data_received", self, "_data_received")

func _ready():
    player = get_tree().get_nodes_in_group("player")[0]
    
    # Check if the settings have been configured.
    if !_settings_valid():
        # If not then quit.
        get_tree().quit()

    get_tree().paused = true

func connect_to_server():
    # Initiate connection to server.
    _client.connect_to_url("localhost:%d" % _settings.data().connection.port)

func _process(delta):
    # Check if connected to the server and poll for packet data if true.
    if _client.get_connection_status() != WebSocketClient.CONNECTION_DISCONNECTED:
        _client.poll()

func _connection_established(protocol):
    # Start authentication process by handshaking with server.
    handshake()

func _connection_error():
    print("Connection Error")

func _data_received():
    print("Data received from server.")
    var peer = _client.get_peer(1)
    # Decode the received packet.
    var packet = WebSocketHelper.decode(peer.get_packet(), peer.was_string_packet())
    if packet.id == PacketIds.PLAYER_AUTH:
        # Authenticate the client.
        handle_auth(packet)

func _settings_valid() -> bool:
    var settings = _settings.data()
    if settings.player.name.empty():
        return false
    return true

func handle_auth(packet):
    var session = packet.session
    _app_id = packet.app_id
    _tokens = packet.tokens
    # Authenticate the TrustedPlatformClient with the session token.
    _tp_client.get_state().auth_user(session.accessToken)
    if _tp_client.get_state().is_authed():
        print("Player client authenticated!")
        # Fetch player's data.
        fetch_player_data()
    else:
        print("Unable to authenticate player client.")

func fetch_player_data():
    var input = GetUserInput.new()
    var udata = { "callback": _fetch_player_data_callback } # Create udata and assign callback.
    input.me(true) # Return result for authenticated player.
    input.user_i.with_identities(true) # Include player's identities.
    input.identity_i.with_linking_code_qr(true) # Include identity linking qr codes.
    input.identity_i.with_wallet(true) # Include identity wallets.
    _tp_client.user_service().get_user(input, udata) # Send get user request.

func load_identity(data):
    _identity = get_identity(data.identities) # Get the identity for the configured app.

    if _identity == null:
        get_tree().quit()

    var linkingCode = _identity.linkingCodeQr
    if linkingCode and !linkingCode.empty():
        download_and_show_qr_code(linkingCode) # Download and display the QR code to the player.
        return

    var wallet = _identity.wallet # Get the wallet from the identity.
    if !wallet:
        return

    var balances = wallet.balances # Get the balances from the wallet.
    for bal in balances: # Iterate over balances and update game state.
        if bal.id == _tokens.crown.id and bal.value > 0: # Check if player has the crown token.
            player.has_crown = true
            player.swap_textures()
            $"../Level/Crown".queue_free()
        elif bal.id == _tokens.key.id and bal.value > 0: # Check if the player has the key token.
            player.has_key = true
            $"../Level/Key".queue_free()
            $"../UI/HUD/HBoxContainer/Key".show()
        elif bal.id == _tokens.health_upgrade.id: # Check if the player has the health upgrade token.
            player.max_health = 5
            player.health += 2
            $"../Level/HealthUpgrade".queue_free()
        elif bal.id == _tokens.shard.id: # Check if player has any coin tokens.
            player.coins_in_wallet = bal.value

    $"../UI/Loading".hide() # Hide the loading screen.
    
    get_tree().paused = false

func get_identity(identities):
    for identity in identities:
        var app_id = int(identity.appId)
        if app_id == _app_id:
            return identity
    return null

func download_and_show_qr_code(url: String):
    if $"../UI/LinkWallet/Rect".texture == null:
        # Create and add new HTTPRequest to the scene.
        var http_request = HTTPRequest.new()
        add_child(http_request)
        # Connect request complete signal.
        http_request.connect("request_completed", self, "_qr_code_request_complete")
        # Send request
        var http_error = http_request.request(url)
        if http_error != OK:
            print("An error occurred in the HTTP request.")
    else:
        show_qr_code()

func show_qr_code():
    $"../UI/Loading".hide()
    $"../UI/LinkWallet".show()

func handshake():
    var packet = {
        "id": PacketIds.HANDSHAKE,
        "name": _settings.data().player.name
    }
    WebSocketHelper.send_packet(_client, packet)

func send_token(name: String, amount: int):
    var packet = {
        "id": PacketIds.SEND_TOKEN,
        "token": name,
        "amount": amount,
        "player_id": int(_identity.id)
    }
    WebSocketHelper.send_packet(_client, packet)

func exit_entered(body):
    player.accept_input = false
    player.velocity = Vector2(0, 0)
    send_token("shard", player.coins) # Send collected coins to the player's wallet.
    $"../UI/GameComplete".show()
    $"../Timer".set_wait_time(.5)
    $"../Timer".start()
    yield($"../Timer", "timeout")
    get_tree().paused = true

func key_grabbed(body):
    send_token("key", 1)

func crown_grabbed(body):
    send_token("crown", 1)

func _fetch_player_data(udata: Dictionary):
    var gql = udata.gql
    if gql.has_errors():
        print("Errors: %s" % PoolStringArray(udata.gql.get_errors()).join(","))
    elif gql.has_result():
        load_identity(gql.get_result())

func _qr_code_request_complete(result, response_code, headers, body):
    # Create image from body
    var image = Image.new()
    var image_error = image.load_png_from_buffer(body)
    if image_error != OK:
        print("Unable to load qr code from url.")
    # Create texture rectangle
    var texture = ImageTexture.new()
    texture.create_from_image(image)
    $"../UI/LinkWallet/Rect".texture = texture
    show_qr_code()

func _wallet_linked():
    $"../UI/Loading".show()
    fetch_player_data()

func health_upgrade_grabbed(body):
    send_token("health_upgrade", 1)
