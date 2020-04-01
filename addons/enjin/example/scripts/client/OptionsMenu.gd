extends PopupPanel
signal options_closed

func _on_close():
    emit_signal("options_closed")
    hide()

func _on_window_item_selected(id):
    match id:
        0: # Full screen
            OS.set_window_fullscreen(true)
        1: # Windowed border
            OS.set_window_fullscreen(false)
            OS.set_borderless_window(false)
        2: # Windowed borderless
            OS.set_borderless_window(true)
            OS.set_window_size(OS.get_screen_size())
            OS.set_window_position(Vector2(0, 0))

func _on_resolution_item_selected(id):
    var size: Vector2
    
    match id:
        0:
            size = Vector2(1280, 1024)
        1:
            size = Vector2(1360, 768)
        2:
            size = Vector2(1366, 768)
        3:
            size = Vector2(1440, 900)
        4:
            size = Vector2(1600, 900)
        5:
            size = Vector2(1680, 1050)
        6:
            size = Vector2(1920, 1080)
        7:
            size = Vector2(2560, 1080)
        8:
            size = Vector2(2560, 1440)
        9:
            size = Vector2(3840, 2160)
        _:
            size = OS.get_window_size()
    
    OS.set_window_size(size)

func _on_vsync_toggled(button_pressed):
    OS.vsync_enabled = !OS.vsync_enabled
