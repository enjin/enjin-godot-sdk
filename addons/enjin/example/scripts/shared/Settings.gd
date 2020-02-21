extends Reference
class_name Settings

enum LoadStatus {
    SUCCESS,
    FAILED_TO_OPEN
}

const WORKING_DIR = "res://working/enjin/"

var _data setget ,data
var _file_path

var _config: ConfigFile = ConfigFile.new()

func _init(defaults: Dictionary, file_name: String):
    _data = defaults
    _file_path = "%s%s" % [WORKING_DIR, file_name]

func save(overwrite: bool = false):
    var dir: Directory = Directory.new()
    var dir_exists: bool = dir.dir_exists(WORKING_DIR)

    if !dir_exists:
        dir.make_dir_recursive(WORKING_DIR)

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
