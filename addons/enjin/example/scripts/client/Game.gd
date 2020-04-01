extends Node2D

func _ready():
    load_main_menu()
    
    # Display loading screen.
    $UI/Loading.show()
    # Initiate connection to server.
    $PlatformClient.connect_to_server()
    # Disable menu buttons while connecting
    $UI/MainMenu.disable_buttons()

func fetch_player():
    $UI/Loading.show()
    $PlatformClient.fetch_player_data()

func load_game():
    fetch_player()
    $Player/Camera.make_current()

func load_main_menu():
    $UI/HUD.hide()
    $UI/MainMenu.show()
    get_tree().paused = true

func unlink_player():
    $UI/Loading.show()
    $PlatformClient.unlink_player()

func _player_fetched():
    $UI/Loading.hide()
    
    if $UI/MainMenu.visible:
        var addr = $PlatformClient._identity.wallet.ethAddress
        
        $UI/MainMenu.show_player_info(addr)
        $UI/MainMenu.enable_buttons()
    else:
        $PlatformClient.load_identity()

func _player_loaded():
    $UI/Loading.hide()
    $UI/HUD.show()
    get_tree().paused = false

func _show_qr(image: Image):
    var texture = ImageTexture.new()
    texture.create_from_image(image)
    
    $UI/Loading.hide()
    
    if $UI/MainMenu.visible:
        $UI/MainMenu.show_qr(texture)
        # Enable menu buttons when QR is available
        $UI/MainMenu.enable_buttons()
    else:
        $UI/LinkWallet/Rect.texture = texture
        $UI/LinkWallet.show()
        get_tree().paused = true
