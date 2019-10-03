tool # required for the script to execute in the editor
extends MenuButton

const id_pressed = "id_pressed"
const on_item_pressed = "_on_item_pressed"
const home_page = "https://enjin.io/"
const docs_page = "https://kovan.cloud.enjin.io/docs/enjin"

# Script references
var EditorHelper = preload("res://addons/enjin/editor/scripts/helpers/EditorHelper.gd")
# Plugin reference
var plugin: EditorPlugin = null setget set_plugin

func _ready():
    var error_code: int = get_popup().connect(id_pressed, self, on_item_pressed)
    log_error(error_code)

func _exit_tree():
    get_popup().disconnect(id_pressed, self, on_item_pressed)

func _on_item_pressed(id):
    var error_code: int = 0

    match id:
        10:
            error_code = OS.shell_open(home_page)
        20:
            error_code = OS.shell_open(docs_page)
        30:
            plugin.reload_plugin()

    log_button_error(text, error_code)

func set_plugin(plugin_in: EditorPlugin):
    plugin = plugin_in

func log_error(code: int):
    if code > 0:
        push_error("Error detected - code: %s" % code)

func log_button_error(button_text: String, code: int):
    if code > 0:
        push_error("Error detected - button: %s, code: %s." % button_text % code)