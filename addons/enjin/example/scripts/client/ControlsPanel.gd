extends PopupPanel
signal start

func _on_btn_mouse_entered():
    $HighlightSFX.play(0)

func _on_btn_pressed():
    $PressedSFX.play(0)

func _on_start():
    hide()
    
    emit_signal("start")
