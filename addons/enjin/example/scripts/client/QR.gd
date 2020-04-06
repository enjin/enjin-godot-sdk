extends Popup
signal wallet_linked

func show():
    .show()
    $Button.grab_focus()
    $Button.grab_click_focus()

func _wallet_linked():
    hide()
    emit_signal("wallet_linked")

func _on_btn_mouse_entered():
    $HighlightSFX.play(0)

func _on_btn_pressed():
    $PressedSFX.play(0)
