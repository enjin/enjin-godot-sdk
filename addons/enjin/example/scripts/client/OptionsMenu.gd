extends PopupPanel
signal options_closed
signal dampen_audio
signal undampen_audio

var _option_open: Control
var _option_open_btn: Button

var _highlight_style: StyleBox = preload("res://addons/enjin/example/themes/options_highlight_stylebox.tres")
var _sfx_test: AudioStream = preload("res://addons/enjin/example/audio/coin_sfx.wav")
var _ui_test: AudioStream = preload("res://addons/enjin/example/audio/ui_blip_sfx.wav")

func _ready():
    var value: float

    # Assigns the slider values based on the mixers'
    value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
    get_tree().get_nodes_in_group("audio_master_slider")[0].value = db2linear(value) * 100
    value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
    get_tree().get_nodes_in_group("audio_music_slider")[0].value = db2linear(value) * 100
    value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
    get_tree().get_nodes_in_group("audio_sfx_slider")[0].value = db2linear(value) * 100
    value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("UI"))
    get_tree().get_nodes_in_group("audio_ui_slider")[0].value = db2linear(value) * 100

    emit_signal("undampen_audio")

func _close_recent_option():
    if _option_open:
        _set_style_box(_option_open_btn, StyleBoxEmpty.new())
        # Signal to restore audio
        if _option_open == $Margin/HBox/OptionsArea/VBox/AudioOptions:
            emit_signal("dampen_audio")
        _option_open.hide()

func _set_style_box(btn: Button, style: StyleBox):
    btn.add_stylebox_override("normal", style)

func _open():
    show()
    _on_video_pressed()

func _on_btn_mouse_entered():
    $HighlightSFX.play(0)

func _on_btn_pressed():
    $PressedSFX.play(0)

func _on_close():
    emit_signal("options_closed")
    hide()
    if _option_open:
        _option_open.hide()

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

func _on_video_pressed():
    _close_recent_option()
    _option_open = $Margin/HBox/OptionsArea/VBox/VideoOptions
    _option_open_btn = $Margin/HBox/Sidebar/Buttons/VBox/Video
    $Margin/HBox/OptionsArea/VBox/VideoOptions.show()
    _set_style_box(_option_open_btn, _highlight_style)

func _on_audio_pressed():
    _close_recent_option()
    _option_open = $Margin/HBox/OptionsArea/VBox/AudioOptions
    _option_open_btn = $Margin/HBox/Sidebar/Buttons/VBox/Audio
    $Margin/HBox/OptionsArea/VBox/AudioOptions.show()
    _set_style_box(_option_open_btn, _highlight_style)

    emit_signal("undampen_audio")

func _on_master_volume_changed(value):
    var db = linear2db(value / 100)
    $Margin/HBox/OptionsArea/VBox/AudioOptions/Buttons/VBox/MasterVolume/Label.text = "%s%%" % value
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)

func _on_music_volume_changed(value):
    var db = linear2db(value / 100)
    $Margin/HBox/OptionsArea/VBox/AudioOptions/Buttons/VBox/MusicVolume/Label.text = "%s%%" % value
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)

func _on_sfx_volume_changed(value):
    var db = linear2db(value / 100)
    $Margin/HBox/OptionsArea/VBox/AudioOptions/Buttons/VBox/SFXVolume/Label.text = "%s%%" % value
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)

func _on_ui_volume_changed(value):
    var db = linear2db(value / 100)
    $Margin/HBox/OptionsArea/VBox/AudioOptions/Buttons/VBox/UIVolume/Label.text = "%s%%" % value
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), db)

func _on_sfx_slider_gui_input(event):
    if event is InputEventMouseButton and !event.pressed:
        $AudioTest.bus = "SFX"
        $AudioTest.set_stream(_sfx_test)
        $AudioTest.play(0)

func _on_ui_slider_gui_input(event):
    if event is InputEventMouseButton and !event.pressed:
        $AudioTest.bus = "UI"
        $AudioTest.set_stream(_ui_test)
        $AudioTest.play(0)
