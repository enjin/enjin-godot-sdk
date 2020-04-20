extends PopupPanel
signal start

func _process(delta):
    var escape = Input.is_action_just_released("ui_cancel")
    
    if visible and escape:
        _on_start()

func show():
    .show()
    $VBox/MarginContainer/Button.grab_focus()
    $VBox/MarginContainer/Button.grab_click_focus()

func _on_btn_mouse_entered():
    $HighlightSFX.play(0)

func _on_btn_pressed():
    $PressedSFX.play(0)

func _on_start():
    hide()
    
    emit_signal("start")
