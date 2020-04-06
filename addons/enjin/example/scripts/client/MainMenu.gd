extends PopupPanel
signal start_game
signal link_wallet
signal unlink_wallet

var _last_wallet_area: PopupPanel

func disable_buttons():
    $HBox/Sidebar.disable_btns()

func enable_buttons():
    $HBox/Sidebar.enable_btns()
    
    if visible:
        $HBox/Sidebar/Buttons/VBox/Start.grab_focus()
        $HBox/Sidebar/Buttons/VBox/Start.grab_click_focus()

func show_loading():
    $LoadingArea.show()
    _update_wallet_focus()

func show_player_info(addr):
    $UnlinkArea/Margin/VBox/Address.text = "%s" % addr

    $UnlinkArea.show()
    $QrCodeArea.hide()
    $LoadingArea.hide()
    _last_wallet_area = $UnlinkArea
    
    _update_wallet_focus($UnlinkArea/Margin/VBox/Unlink)

func show_qr(texture: ImageTexture):
    # Fixes the texture to the rect's size
    texture.set_size_override($QrCodeArea/VBox/Qr.rect_min_size)

    $QrCodeArea/VBox/Qr.texture = texture
    $QrCodeArea.show()
    $UnlinkArea.hide()
    $LoadingArea.hide()
    _last_wallet_area = $QrCodeArea
    
    _update_wallet_focus($QrCodeArea/VBox/Link)

func _update_wallet_focus(walletButton: Button = null):
    var btns = get_tree().get_nodes_in_group("main_menu_btns")
    for i in range(0, len(btns)):
        var btn: Button = btns[i]
        if walletButton:
            btn.focus_neighbour_right = walletButton.get_path()
        else:
            btn.focus_neighbour_right = btn.get_path()

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
        if visible:
            _last_wallet_area.show()
        enable_buttons()

func _on_btn_mouse_entered():
    $HighlightSFX.play(0)

func _on_btn_pressed():
    $PressedSFX.play(0)

func _on_link_pressed():
    emit_signal("link_wallet")

func _on_unlink_pressed():
    emit_signal("unlink_wallet")
