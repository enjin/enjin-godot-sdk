extends Popup
signal paused
signal unpaused

var _viewing_options = false

func _process(delta):
    var escape = Input.is_action_just_released("ui_cancel")

    if escape and visible and !_viewing_options:
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
    $HBox/Sidebar/Buttons/VBox/ResumeBtn.grab_focus()
    $HBox/Sidebar/Buttons/VBox/ResumeBtn.grab_click_focus()
    
    emit_signal("paused")

func _resume():
    get_tree().paused = false
    hide()
    emit_signal("unpaused")

func _on_options():
    if not $"../OptionsMenu".visible:
        $"../OptionsMenu".show()
        $HBox/Sidebar.disable_btns()
        _viewing_options = true
    else:
        $HBox/Sidebar.enable_btns()
        _viewing_options = false
        
        if visible:
            $"../..".dampen_audio()
            $HBox/Sidebar/Buttons/VBox/ResumeBtn.grab_focus()
            $HBox/Sidebar/Buttons/VBox/ResumeBtn.grab_click_focus()
