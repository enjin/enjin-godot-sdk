extends PopupPanel
signal start_game
signal link_wallet
signal unlink_wallet
signal name_enter
signal name_reset

# Constants
const name_error_text: String = "Invalid Name:\nmust contain only letters and/or numbers"

var _last_wallet_area: PopupPanel
var _allow_start: bool = true
var _has_player_name: bool = false

func disable_buttons():
    $HBox/Sidebar.disable_btns()
    $ResetNameBox/Margin/VBox/Button.disabled = true

func enable_buttons():
    $HBox/Sidebar.enable_btns()
    $ResetNameBox/Margin/VBox/Button.disabled = false
    
    if !_allow_start:
        $HBox/Sidebar/Buttons/VBox/Start.disabled = true
    
    if visible:
        $HBox/Sidebar/Buttons/VBox/Start.grab_focus()
        $HBox/Sidebar/Buttons/VBox/Start.grab_click_focus()

func allow_start(allow: bool = true):
    _allow_start = allow
    
    var btns_disabled = $HBox/Sidebar.btns_disabled()
    if allow and !btns_disabled:
        $HBox/Sidebar/Buttons/VBox/Start.disabled = false
    elif !allow and !btns_disabled:
        $HBox/Sidebar/Buttons/VBox/Start.disabled = true

func show_loading():
    _show_area($LoadingArea)
    _update_wallet_focus()

func show_name_error():
    if $PlayerNameArea.visible:
        $PlayerNameArea/Margin/VBox/VBox/Error.text = name_error_text

func hide_name_error():
    $PlayerNameArea/Margin/VBox/VBox/Error.text = ""

func show_name_input():
    hide_name_error()
    _show_area($PlayerNameArea)
    _update_wallet_focus($PlayerNameArea/Margin/VBox/Button)

func hide_reset_name_option():
    $ResetNameBox.hide()

func show_reset_name_option(name: String):
    if name.empty():
        return
    
    _has_player_name = true
    $ResetNameBox/Margin/VBox/Label.text = name
    $PlayerNameArea/Margin/VBox/VBox/Input.text = ""
    $ResetNameBox.show()

func show_player_info(addr):
    $UnlinkArea/Margin/VBox/Address.text = "%s" % addr
    _show_area($UnlinkArea)
    _update_wallet_focus($UnlinkArea/Margin/VBox/Unlink)

func show_qr(texture: ImageTexture):
    # Fixes the texture to the rect's size
    texture.set_size_override($QrCodeArea/VBox/Qr.rect_min_size)
    $QrCodeArea/VBox/Qr.texture = texture
    _show_area($QrCodeArea)
    _update_wallet_focus($QrCodeArea/VBox/Link)

func _show_area(area: Control):
    var areas = get_tree().get_nodes_in_group("main_menu_areas")
    for i in range(0, len(areas)):
        areas[i].hide()
    
    area.show()
    _last_wallet_area = area

func _update_wallet_focus(walletButton: Button = null):
    var btns = get_tree().get_nodes_in_group("main_menu_btns")
    for i in range(0, len(btns)):
        var btn: Button = btns[i]
        if walletButton:
            btn.focus_neighbour_right = walletButton.get_path()
        else:
            btn.focus_neighbour_right = btn.get_path()
    
    if walletButton and walletButton != $PlayerNameArea/Margin/VBox/Button:
        var resetNameBtn: Button = $ResetNameBox/Margin/VBox/Button
        resetNameBtn.focus_neighbour_bottom = walletButton.get_path()
        walletButton.focus_neighbour_top = resetNameBtn.get_path()

func _hide_areas():
    $ResetNameBox.hide()
    var areas = get_tree().get_nodes_in_group("main_menu_areas")
    for i in range(0, len(areas)):
        var area: Control = areas[i]
        area.hide()

func _on_start():
    hide()
    _hide_areas()
    emit_signal("start_game")

func _on_exit():
    get_tree().quit()

func _on_options():
    if not $"../OptionsMenu".visible:
        $"../OptionsMenu".show()
        _hide_areas()
        disable_buttons()
    else:
        if visible:
            _last_wallet_area.show()
            if _has_player_name:
                $ResetNameBox.show()
        enable_buttons()

func _on_btn_mouse_entered():
    $HighlightSFX.play(0)

func _on_btn_pressed():
    $PressedSFX.play(0)

func _on_link_pressed():
    emit_signal("link_wallet")

func _on_unlink_pressed():
    emit_signal("unlink_wallet")

func _on_name_enter_pressed():
    var name: String = $PlayerNameArea/Margin/VBox/VBox/Input.text
    emit_signal("name_enter", name)

func _on_name_reset_pressed():
    _has_player_name = false
    emit_signal("name_reset")
