extends PopupPanel
signal options_closed
signal dampen_audio
signal undampen_audio

# Constants
const SETTINGS_FILE_NAME: String  = "user://config.ini"

var _option_open: Control
var _option_open_btn: Button
var _settings: ConfigFile
var _has_applied_settings: bool

var _highlight_style: StyleBox = preload("res://addons/enjin/example/themes/options_highlight_stylebox.tres")
var _sfx_test: AudioStream = preload("res://addons/enjin/example/audio/coin_sfx.wav")
var _ui_test: AudioStream = preload("res://addons/enjin/example/audio/ui_blip_sfx.wav")

func _ready():
    _settings = ConfigFile.new()
    
    if _settings.load(SETTINGS_FILE_NAME) != OK:
        _settings.save(SETTINGS_FILE_NAME)

    _load_settings()

    # Undampen in case of returning to main menu from pause menu
    emit_signal("undampen_audio")

func _process(delta):
    var enter = Input.is_action_just_released("ui_accept")
    var escape = Input.is_action_just_released("ui_cancel")
    
    if visible:
        if enter:
            _on_apply()
        elif escape:
            _on_close()

func _close_recent_option():
    if _option_open:
        _set_style_box(_option_open_btn, StyleBoxEmpty.new())
        # Signal to restore audio
        if _option_open == $Margin/HBox/OptionsArea/VBox/AudioOptions:
            emit_signal("dampen_audio")
        _option_open.hide()

func _load_settings():
    var value
    
    # Video settings
    value = _settings.get_value("video", "window", 1)
    get_tree().get_nodes_in_group("video_window_btn")[0].select(value)
    _on_window_item_selected(value) # Applies button selection
    value = _settings.get_value("video", "resolution", 6)
    get_tree().get_nodes_in_group("video_resolution_btn")[0].select(value)
    _on_resolution_item_selected(value) # Applies button selection
    value = _settings.get_value("video", "vsync", true)
    get_tree().get_nodes_in_group("video_vsync_btn")[0].pressed = value
    
    # Audio settings
    value = _settings.get_value("audio", "master", 100)
    get_tree().get_nodes_in_group("audio_master_slider")[0].value = value
    value = _settings.get_value("audio", "music", 100)
    get_tree().get_nodes_in_group("audio_music_slider")[0].value = value
    value = _settings.get_value("audio", "sfx", 100)
    get_tree().get_nodes_in_group("audio_sfx_slider")[0].value = value
    value = _settings.get_value("audio", "ui", 100)
    get_tree().get_nodes_in_group("audio_ui_slider")[0].value = value
    
    _settings_changed(false)

func _open():
    show()
    _on_video_pressed() # Automatically opens video tab

func _save_settings():
    var value
    
    # Video settings
    value = get_tree().get_nodes_in_group("video_window_btn")[0].selected
    _settings.set_value("video", "window", value)
    value = get_tree().get_nodes_in_group("video_resolution_btn")[0].selected
    _settings.set_value("video", "resolution", value)
    value = get_tree().get_nodes_in_group("video_vsync_btn")[0].pressed
    _settings.set_value("video", "vsync", value)
    
    # Audio settings
    value = get_tree().get_nodes_in_group("audio_master_slider")[0].value
    _settings.set_value("audio", "master", value)
    value = get_tree().get_nodes_in_group("audio_music_slider")[0].value
    _settings.set_value("audio", "music", value)
    value = get_tree().get_nodes_in_group("audio_sfx_slider")[0].value
    _settings.set_value("audio", "sfx", value)
    value = get_tree().get_nodes_in_group("audio_ui_slider")[0].value
    _settings.set_value("audio", "ui", value)
    
    _settings.save(SETTINGS_FILE_NAME)

func _set_style_box(btn: Button, style: StyleBox):
    btn.add_stylebox_override("normal", style)

func _settings_changed(changed: bool):
    if changed:
        _has_applied_settings = false
        get_tree().get_nodes_in_group("options_apply_btn")[0].disabled = false
    else:
        _has_applied_settings = true
        get_tree().get_nodes_in_group("options_apply_btn")[0].disabled = true

func _on_apply():
    _save_settings()
    _settings_changed(false)

func _on_btn_mouse_entered():
    $HighlightSFX.play(0)

func _on_btn_pressed():
    $PressedSFX.play(0)

func _on_close():
    if !_has_applied_settings:
        _load_settings()
    
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
    
    _settings_changed(true)

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
    
    _settings_changed(true)

func _on_vsync_toggled(button_pressed):
    OS.vsync_enabled = button_pressed
    
    _settings_changed(true)

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
    
    $Margin/HBox/OptionsArea/VBox/AudioOptions/Buttons/VBox/MasterVolume/Label.text = "%s" % value
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
    
    _settings_changed(true)

func _on_music_volume_changed(value):
    var db = linear2db(value / 100)
    
    $Margin/HBox/OptionsArea/VBox/AudioOptions/Buttons/VBox/MusicVolume/Label.text = "%s" % value
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)
    
    _settings_changed(true)

func _on_sfx_volume_changed(value):
    var db = linear2db(value / 100)
    
    $Margin/HBox/OptionsArea/VBox/AudioOptions/Buttons/VBox/SFXVolume/Label.text = "%s" % value
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)
    
    _settings_changed(true)

func _on_ui_volume_changed(value):
    var db = linear2db(value / 100)
    
    $Margin/HBox/OptionsArea/VBox/AudioOptions/Buttons/VBox/UIVolume/Label.text = "%s" % value
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), db)
    
    _settings_changed(true)

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
