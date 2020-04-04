extends Popup
signal paused
signal unpaused

func _process(delta):
    var escape = Input.is_action_just_released("ui_cancel")

    if escape and visible:
        _resume()
    elif escape and not visible and not get_tree().paused:
        _pause()

func _on_btn_mouse_entered():
    $HighlightSFX.play(0)

func _on_btn_pressed():
    $PressedSFX.play(0)

func _on_resume():
    _resume()

func _on_quit():
    get_tree().reload_current_scene()

func _pause():
    get_tree().paused = true
    show()
    emit_signal("paused")

func _resume():
    get_tree().paused = false
    hide()
    emit_signal("unpaused")

func _on_options():
    if not $"../OptionsMenu".visible:
        $"../OptionsMenu"._open()
        $HBoxContainer/Sidebar.disable_btns()
    else:
        if visible:
            $"../..".dampen_audio()
        $HBoxContainer/Sidebar.enable_btns()
