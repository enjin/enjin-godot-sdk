tool # required for the script to execute in the editor
extends MenuButton

var plugin: EditorPlugin = null setget set_plugin

func set_plugin(plugin_in):
    plugin = plugin_in

func _ready():
    get_popup().connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(id):
    var text = get_popup().get_item_text(id)
    match text:
        "Home":
            OS.shell_open("https://enjin.io/")