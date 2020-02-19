extends Node2D
signal update_hud

export var respawn_height = 1500

func _ready():
    respawn($Player)

func _process(delta):
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
        # TODO: Implement level complete and send to player wallet
        send_tokens()

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
            "value": $Player.coins
        })

    service.create_request(input, udata)

func _send_token_callback(udata: Dictionary):
#    print("Call: %s" % udata.call.get_body())
    print("URL: %s" % Enjin.client._base_url)
    if udata.gql.has_errors():
        print("Errors: %s" % PoolStringArray(udata.gql.get_errors()).join(","))
    get_tree().reload_current_scene()