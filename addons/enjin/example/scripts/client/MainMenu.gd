extends PopupPanel
signal start_game
signal link_wallet
signal unlink_wallet

var _last_wallet_area: PopupPanel

func disable_buttons():
    $HBox/Sidebar.disable_btns()

func enable_buttons():
    $HBox/Sidebar.enable_btns()

func show_player_info(addr):
    $UnlinkArea/Margin/VBox/Address.text = "%s" % addr
    
    $UnlinkArea.show()
    $QrCodeArea.hide()
    _last_wallet_area = $UnlinkArea

func show_qr(texture: ImageTexture):
    # Fixes the texture to the rect's size
    texture.set_size_override($QrCodeArea/VBox/Qr.rect_min_size)
    
    $QrCodeArea/VBox/Qr.texture = texture
    $QrCodeArea.show()
    $UnlinkArea.hide()
    _last_wallet_area = $QrCodeArea

func _on_start():
    # Hides all ui elements
    hide()
    $QrCodeArea.hide()
    $UnlinkArea.hide()
    
    emit_signal("start_game")

func _on_exit():
    get_tree().quit()

func _on_options():
    if not $"../OptionsMenu".visible:
        $"../OptionsMenu".show()
        $QrCodeArea.hide()
        $UnlinkArea.hide()
        disable_buttons()
    else:
        _last_wallet_area.show()
        enable_buttons()

func _on_link_pressed():
    emit_signal("link_wallet")

func _on_unlink_pressed():
    emit_signal("unlink_wallet")
