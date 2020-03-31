extends PopupPanel
signal start_game

func _ready():
    show()

func _on_start():
    hide()
    emit_signal("start_game")

func _on_exit():
    get_tree().quit()

func _on_options():
    if not $"../OptionsMenu".visible:
        $"../OptionsMenu".show()
    else:
        $HBoxContainer/Sidebar.enable_btns()
