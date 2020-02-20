extends Node2D
signal update_hud

const PORT = 11011
const WRITE_MODE = WebSocketPeer.WRITE_MODE_BINARY

export var respawn_height = 1500

var _client

func _ready():
    var t = Timer.new()
    t.set_wait_time(1)
    t.set_one_shot(true)
    self.add_child(t);
    t.start()
    yield(t, "timeout")

    t.queue_free()

    _client = WebSocketClient.new()
    _client.connect_to_url("localhost:%d" % PORT)
    _client.connect("connection_established", self, "_connection_established")
    _client.connect("connection_error", self, "_connection_error")
    _client.connect("data_received", self, "_data_received")

    respawn($Player)

func _connection_established(protocol):
    print("Client connected with protocol: %s" % protocol)

func _connection_error():
    print("Connection Error")

func coins_collected(amount: int):
    var packet = {
        "id": 0,
        "amount": amount
    }
    send_data(packet)

func exiting():
    var packet = {
        "id": 1
    }
    send_data(packet)

func send_data(data):
    print(data)
    var peer = _client.get_peer(1)
    peer.set_write_mode(WRITE_MODE)
    peer.put_packet(var2bytes(data))

func _process(delta):
    if _client != null && _client.get_connection_status() != WebSocketClient.CONNECTION_DISCONNECTED:
        _client.poll()

    if $Player.position.y > respawn_height:
        $Player.health = max(0, $Player.health - 1)

        if $Player.health == 0:
            get_tree().reload_current_scene()
            return

        respawn($Player)
        emit_signal("update_hud", $Player)

func respawn(player):
    player.position.x = $Spawn.position.x
    player.position.y = $Spawn.position.y

func exit_entered(body):
    if $Player.coins == 3:
        exiting()

func _data_received():
    var packet = _client.get_peer(1).get_packet()
    var data = bytes2var(packet)
    print(data)
    if data.id == 2:
        $Canvas/Ending.show()
        get_tree().paused = true