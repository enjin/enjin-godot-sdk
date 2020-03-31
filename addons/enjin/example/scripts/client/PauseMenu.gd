extends Popup

func _process(delta):
    var escape = Input.is_action_just_released("ui_cancel")

    if escape and visible:
        _resume()
    elif escape and not visible and not get_tree().paused:
        _pause()

func _on_resume():
    _resume()

func _on_options():
    pass # Replace with function body.

func _on_quit():
    get_tree().reload_current_scene()

func _pause():
    get_tree().paused = true
    show()

func _resume():
    get_tree().paused = false
    hide()
