extends PopupPanel

func show():
    .show()
    $CenterContainer/VBoxContainer/Button.grab_focus()
    $CenterContainer/VBoxContainer/Button.grab_click_focus()

func _on_btn_mouse_entered():
    $HighlightSFX.play(0)

func _on_btn_pressed():
    $PressedSFX.play(0)
