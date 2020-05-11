extends Node2D

var _bg_music: AudioStream = preload("res://addons/enjin/example/audio/dungeon.ogg")
var _end_music: AudioStream = preload("res://addons/enjin/example/audio/ending.ogg")

func _ready():
    load_main_menu()
    $BgMusic.play(0)

    # Initiate connection to server.
    $PlatformClient.connect_to_server()
    # Disable menu buttons while connecting
    $UI/MainMenu.disable_buttons()

func end_level(body = null):
    $Player.accept_input = false
    $Player.velocity = Vector2(0, 0)

    $UI/GameComplete.show()
    get_tree().paused = true

func dampen_audio():
    if !$UI/MainMenu.visible:
        var bus = AudioServer.get_bus_index("Music")
        var value = get_tree().get_nodes_in_group("audio_music_slider")[0].value / 1000
        AudioServer.set_bus_volume_db(bus, linear2db(value))
        AudioServer.set_bus_effect_enabled(bus, 0, true)

func fetch_player():
    $UI/Loading.show()
    $UI/MainMenu.disable_buttons()
    $PlatformClient.fetch_player_data()

func load_game():
    fetch_player()
    $Player/Camera.make_current()

func load_main_menu():
    $UI/HUD.hide()
    $UI/MainMenu.show()
    _show_loading()
    get_tree().paused = true

func play_ending_track():
    $BgMusic.stop()
    $BgMusic.set_stream(_end_music)
    $BgMusic.play(0)

func start_level():
    $UI/HUD.show()

    get_tree().paused = false

func undampen_audio():
    var bus = AudioServer.get_bus_index("Music")
    var value = get_tree().get_nodes_in_group("audio_music_slider")[0].value / 100
    AudioServer.set_bus_volume_db(bus, linear2db(value))
    AudioServer.set_bus_effect_enabled(bus, 0, false)

func unlink_player():
    $UI/Loading.show()
    $UI/MainMenu.disable_buttons()
    $PlatformClient.unlink_player()

func reset_player_name():
    # May only reset name at main menu
    if not $UI/MainMenu.visible:
        return
    
    $UI/MainMenu.hide_reset_name_option()
    
    $PlatformClient.clear_name()
    unlink_player()
    $PlatformClient.init_handshake()

func update_player_name(name: String):
    if $PlatformClient.update_name(name) and $UI/MainMenu.visible:
        $UI/MainMenu.hide_name_error()
        $PlatformClient.init_handshake()
    elif $UI/MainMenu.visible:
        $UI/MainMenu.show_name_error()

func _paused():
    dampen_audio()

func _player_fetched():
    if $PlatformClient.player_name().empty():
        return
    
    $UI/Loading.hide()

    if $UI/MainMenu.visible:
        var addr = $PlatformClient._identity.wallet.ethAddress

        $UI/MainMenu.show_player_info(addr)
        $UI/MainMenu.show_reset_name_option($PlatformClient.player_name())
        $UI/MainMenu.allow_start(true)
        $UI/MainMenu.enable_buttons()
    else:
        $PlatformClient.load_identity()

func _player_loaded():
    var show_controls: bool = get_tree().get_nodes_in_group("general_controls_btn")[0].pressed

    $UI/Loading.hide()

    if show_controls:
        $UI/ControlsPanel.show()
    else:
        start_level()

func _show_loading():
    if $UI/MainMenu.visible:
        $UI/MainMenu.show_loading()
        $UI/MainMenu.hide_reset_name_option()
        $UI/MainMenu.disable_buttons()

func _show_name_input():
    $UI/Loading.hide()
    
    if $UI/MainMenu.visible:
        $UI/MainMenu.show_name_input()
        $UI/MainMenu.allow_start(false)
        $UI/MainMenu.enable_buttons()

func _show_qr(image: Image):
    if $PlatformClient.player_name().empty():
        return
    
    var texture = ImageTexture.new()
    texture.create_from_image(image)

    $UI/Loading.hide()

    if $UI/MainMenu.visible:
        $UI/MainMenu.show_qr(texture)
        $UI/MainMenu.show_reset_name_option($PlatformClient.player_name())
        # Enable menu buttons when QR is available
        $UI/MainMenu.allow_start(true)
        $UI/MainMenu.enable_buttons()
    else:
        $UI/LinkWallet/Rect.texture = texture
        $UI/LinkWallet.show()
        get_tree().paused = true

func _unpaused():
    undampen_audio()
