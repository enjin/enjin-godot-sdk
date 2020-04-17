extends PopupPanel
signal start

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
