extends Node2D

func _ready():
    load_main_menu()

func load_game():
    $Player/Camera.make_current()
    $UI/HUD.show()
    
    # Display loading screen.
    $UI/Loading.show()

    # Initiate connection to server.
    $PlatformClient.connect_to_server()

func load_main_menu():
    $UI/HUD.hide()
