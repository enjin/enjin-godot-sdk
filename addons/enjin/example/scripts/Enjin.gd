extends Node

enum {
    LOAD_SUCCESS,
    LOAD_ERROR_COULDNT_OPEN
}

const SAVE_DIRECTORY: String = "res://working/enjin/"
const SAVE_PATH: String = SAVE_DIRECTORY + "config.cfg"

var TrustedPlatformClient = preload("res://addons/enjin/sdk/TrustedPlatformClient.gd")

var client: TrustedPlatformClient
var config: ConfigFile = ConfigFile.new()
var settings = {
    "developer": {
        "ident_id": -1
    },
    "app": {
        "secret": "",
        "id": -1
    },
    "token": {
        "id": ""
    },
    "player": {
        "ident_id": -1
    }
}

func _init():
    _save_settings()
    _load_settings()
    client = TrustedPlatformClient.new()

func _ready():
    if !_is_config_valid():
        get_tree().quit()

    var callback = EnjinCallback.new(self, "_post_auth")
    Enjin.client.auth_service().auth_app(settings.app.id, settings.app.secret, { "callback": callback })

func _post_auth(udata: Dictionary):
    print("Client Authenticated: %s" % Enjin.client.get_state().is_authed())

func _is_config_valid() -> bool:
    if settings.developer.ident_id < 0:
        return false

    if settings.app.secret.empty() or settings.app.id < 0:
        return false

    if settings.token.id.empty():
        return false

    if settings.player.ident_id < 0:
        return false

    return true

func _save_settings():
    var dir: Directory = Directory.new()
    var dir_exists: bool = dir.dir_exists(SAVE_DIRECTORY)

    if !dir_exists:
        dir.make_dir_recursive(SAVE_DIRECTORY)

    var file_exists: bool = dir.file_exists(SAVE_PATH)

    if file_exists:
        return

    for section in settings.keys():
        for key in settings[section].keys():
            config.set_value(section, key, settings[section][key])
    config.save(SAVE_PATH)

func _load_settings():
    var error = config.load(SAVE_PATH)
    if error != OK:
        print("Error loading the settings. Error code: %s" % error)
        return LOAD_ERROR_COULDNT_OPEN

    for section in settings.keys():
        for key in settings[section].keys():
            var val = config.get_value(section, key)
            settings[section][key] = val
    return LOAD_SUCCESS