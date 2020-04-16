extends PopupPanel
signal options_closed
signal dampen_audio
signal undampen_audio

# Constants
const AUDIO_TEST_INPUT_WAIT: float = 0.5 # Wait between slider input and audio test
const SETTINGS_FILE_NAME: String  = "user://config.ini"

var _option_open: Control
var _option_open_btn: Button
var _settings: ConfigFile
var _has_applied_settings: bool

var _highlight_normal_style: StyleBox = preload("res://addons/enjin/example/themes/options_highlight_stylebox.tres")
var _highlight_hover_style: StyleBox = preload("res://addons/enjin/example/themes/options_highlight_stylebox_hover.tres")
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
    var select = Input.is_action_just_released("ui_select")

    if visible:
        if escape:
            _on_close()
            _on_btn_pressed()
        elif select:
            _on_apply()
            _on_btn_pressed()
        elif enter:
            # Handles focus for sliders
            var group = get_tree().get_nodes_in_group("audio_sliders")
            for i in range(0, len(group)):
                var node: Control = group[i]
                if node.has_focus():
                    _option_open_btn.grab_focus()
                    _option_open_btn.grab_click_focus()
                    _on_btn_pressed()

func show():
    .show()
    _on_general_pressed() # Automatically opens general tab
    _update_focus()
    $Margin/HBox/Sidebar/Buttons/VBox/General.grab_focus()
    $Margin/HBox/Sidebar/Buttons/VBox/General.grab_click_focus()

func _close_recent_option():
    if _option_open:
        _set_style_box(_option_open_btn, false)
        # Signal to restore audio
        if _option_open == $Margin/HBox/OptionsArea/VBox/AudioOptions:
            emit_signal("dampen_audio")
        _option_open.hide()

func _load_settings():
    var value

    # General
    value = _settings.get_value("general", "controls", true)
    get_tree().get_nodes_in_group("general_controls_btn")[0].pressed = value

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

func _play_test_sfx():
    if $AudioTest.playing:
        $AudioTest.stop()
    $AudioTest.bus = "SFX"
    $AudioTest.set_stream(_sfx_test)
    $AudioTest.play(0)

func _play_test_ui():
    if $AudioTest.playing:
        $AudioTest.stop()
    $AudioTest.bus = "UI"
    $AudioTest.set_stream(_ui_test)
    $AudioTest.play(0)

func _save_settings():
    var value

    # General options
    value = get_tree().get_nodes_in_group("general_controls_btn")[0].pressed
    _settings.set_value("general", "controls", value)

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

func _set_style_box(btn: Button, enable: bool):
    if enable:
        btn.add_stylebox_override("hover", _highlight_hover_style)
        btn.add_stylebox_override("pressed", _highlight_normal_style)
        btn.add_stylebox_override("focus", _highlight_hover_style)
        btn.add_stylebox_override("normal", _highlight_normal_style)
    else:
        btn.add_stylebox_override("hover", null)
        btn.add_stylebox_override("pressed", null)
        btn.add_stylebox_override("focus", null)
        btn.add_stylebox_override("normal", null)

func _settings_changed(changed: bool):
    if changed:
        _has_applied_settings = false
        get_tree().get_nodes_in_group("options_apply_btn")[0].disabled = false
        get_tree().get_nodes_in_group("options_apply_btn")[0].focus_mode = Control.FOCUS_ALL
    else:
        _has_applied_settings = true
        get_tree().get_nodes_in_group("options_apply_btn")[0].disabled = true
        get_tree().get_nodes_in_group("options_apply_btn")[0].focus_mode = Control.FOCUS_NONE

func _update_focus():
    var node: NodePath

    # Gets the option to set as right focus
    if _option_open == $Margin/HBox/OptionsArea/VBox/GeneralOptions:
        node = $Margin/HBox/OptionsArea/VBox/GeneralOptions/Button/VBox/ShowControls.get_path()
    elif _option_open == $Margin/HBox/OptionsArea/VBox/VideoOptions:
        node = $Margin/HBox/OptionsArea/VBox/VideoOptions/Button/VBox/Window.get_path()
    elif _option_open == $Margin/HBox/OptionsArea/VBox/AudioOptions:
        node = $Margin/HBox/OptionsArea/VBox/AudioOptions/Buttons/VBox/MasterVolume/Slider.get_path()

    $Margin/HBox/Sidebar/Buttons/VBox/General.focus_neighbour_right = node
    $Margin/HBox/Sidebar/Buttons/VBox/Video.focus_neighbour_right = node
    $Margin/HBox/Sidebar/Buttons/VBox/Audio.focus_neighbour_right = node

func _on_apply():
    $Margin/HBox/OptionsArea/VBox/Bottombar/HBox/Close.grab_focus()
    $Margin/HBox/OptionsArea/VBox/Bottombar/HBox/Close.grab_click_focus()
    _save_settings()
    _settings_changed(false)

func _on_btn_mouse_entered():
    $HighlightSFX.play(0)

func _on_btn_pressed():
    $PressedSFX.play(0)

func _on_close():
    $SFXTestTimer.stop()
    $UITestTimer.stop()

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

func _on_show_controls_toggled(button_pressed):
    _settings_changed(true)

func _on_vsync_toggled(button_pressed):
    OS.vsync_enabled = button_pressed

    _settings_changed(true)

func _on_general_pressed():
    _close_recent_option()
    _option_open = $Margin/HBox/OptionsArea/VBox/GeneralOptions
    _option_open_btn = $Margin/HBox/Sidebar/Buttons/VBox/General
    $Margin/HBox/OptionsArea/VBox/GeneralOptions.show()
    _set_style_box(_option_open_btn, true)
    _update_focus()

func _on_video_pressed():
    _close_recent_option()
    _option_open = $Margin/HBox/OptionsArea/VBox/VideoOptions
    _option_open_btn = $Margin/HBox/Sidebar/Buttons/VBox/Video
    $Margin/HBox/OptionsArea/VBox/VideoOptions.show()
    _set_style_box(_option_open_btn, true)
    _update_focus()

func _on_audio_pressed():
    _close_recent_option()
    _option_open = $Margin/HBox/OptionsArea/VBox/AudioOptions
    _option_open_btn = $Margin/HBox/Sidebar/Buttons/VBox/Audio
    $Margin/HBox/OptionsArea/VBox/AudioOptions.show()
    _set_style_box(_option_open_btn, true)
    _update_focus()

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

    if visible:
        $SFXTestTimer.start(AUDIO_TEST_INPUT_WAIT)

func _on_ui_volume_changed(value):
    var db = linear2db(value / 100)

    $Margin/HBox/OptionsArea/VBox/AudioOptions/Buttons/VBox/UIVolume/Label.text = "%s" % value
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), db)

    _settings_changed(true)

    if visible:
        $UITestTimer.start(AUDIO_TEST_INPUT_WAIT)

func _on_sfx_slider_gui_input(event):
    if event is InputEventMouseButton and !event.pressed:
        $SFXTestTimer.stop()
        _play_test_sfx()

func _on_ui_slider_gui_input(event):
    if event is InputEventMouseButton and !event.pressed:
        $UITestTimer.stop()
        _play_test_ui()
