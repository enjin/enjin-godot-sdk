extends Node

const PORT = 11011

var _server = WebSocketServer.new()
var _clients = {}
var _write_mode = WebSocketPeer.WRITE_MODE_BINARY
var _last_connected_client = 0
var _tokens_collected = 0

func _init():
    print("hello")
    _server.connect("client_connected", self, "_client_connected")
    _server.connect("data_received", self, "_data_received")

func _ready():
    _server.listen(PORT)

func _exit_tree():
    _clients.clear()
    _server.stop()

func _process(delta):
    if _server.is_listening():
        _server.poll()

func _client_connected(id, protocol):
    _clients[id] = _server.get_peer(id)
    _clients[id].set_write_mode(_write_mode)
    _last_connected_client = id
    print("%s: Client connected with protocol %s" % [id, protocol])

func _data_received(id):
    print("Data received from %s" % id)
    var packet = _server.get_peer(id).get_packet()
    var data = bytes2var(packet)
    if data.id == 0:
        print("collected")
        _tokens_collected += 1
    elif data.id == 1:
        send_tokens()
        _tokens_collected = 0

        var t = Timer.new()
        t.set_wait_time(.1)
        t.set_one_shot(true)
        self.add_child(t);
        t.start()
        yield(t, "timeout")

        t.queue_free()
        reset(id)

func reset(id):
    var packet = {
        "id": 2
    }
    send_data(id, packet)

func send_data(id, data):
    _server.get_peer(id).put_packet(var2bytes(data))

func send_tokens():
    var settings = Enjin.settings
    var client = Enjin.client
    var service = client.request_service()
    var input = CreateRequestInput.new()
    var udata = { "callback": EnjinCallback.new(self, "_send_token_callback") }

    input.app_id(settings.app.id)
    input.tx_type("SEND")
    input.identity_id(settings.developer.ident_id)
    input.send_token({
            "token_id": settings.token.id,
            "recipient_identity_id": settings.player.ident_id,
            "value": _tokens_collected
        })

    service.create_request(input, udata)

func _send_token_callback(udata: Dictionary):
    if udata.gql.has_errors():
        print("Errors: %s" % PoolStringArray(udata.gql.get_errors()).join(","))
