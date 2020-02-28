extends Reference
class_name Settings

enum LoadStatus {
    SUCCESS,
    FAILED_TO_OPEN
}

const WORKING_DIR = "res://working/config"
const USER_DIR = "user://config"

var _data setget ,data
var _directory
var _file_path

var _config: ConfigFile = ConfigFile.new()

func _init(defaults: Dictionary, file_name: String):
    _data = defaults
    _directory = "%s/config" % get_game_directory() if OS.has_feature("standalone") else WORKING_DIR
    _file_path = "%s/%s" % [_directory, file_name]

func save(overwrite: bool = false):
    var dir: Directory = Directory.new()
    var dir_exists: bool = dir.dir_exists(_directory)
    if !dir_exists:
        var error = dir.make_dir_recursive(_directory)
        print("Error creating directories. Error code: %s" % error)
        return

    var file_exists: bool = dir.file_exists(_file_path)

    if file_exists and !overwrite:
        return

    for section in _data.keys():
        for key in _data[section].keys():
            _config.set_value(section, key, _data[section][key])
    _config.save(_file_path)

func load():
    var error = _config.load(_file_path)
    if error != OK:
        print("Error loading the settings. Error code: %s" % error)
        return LoadStatus.FAILED_TO_OPEN

    for section in _data.keys():
        for key in _data[section].keys():
            _data[section][key] = _config.get_value(section, key)
    return LoadStatus.SUCCESS

func data() -> Dictionary:
    return _data

static func get_game_directory():
    var ex_path = OS.get_executable_path()
    return ex_path.substr(0, ex_path.find_last("\\"))
