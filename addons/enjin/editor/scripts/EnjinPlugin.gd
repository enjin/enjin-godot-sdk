tool
extends EditorPlugin

const directory_name = "enjin"

# Script references
var EditorHelper = preload("res://addons/enjin/editor/scripts/helpers/EditorHelper.gd")
# Toolbar ui template
var toolbar_tscn = preload("res://addons/enjin/editor/views/toolbar_menu.tscn")
# Editor's primary toolbar (e.g. Scene Project Debug Editor Help)
var editor_toolbar: Node = null
# Toolbar ui instance
var toolbar: Node = null

func _enter_tree():
    connect("resource_saved", self, "resource_saved_listener")
    if editor_toolbar == null:
        editor_toolbar = EditorHelper.get_primary_toolbar(self)
    remove_orphans(editor_toolbar)
    reload_toolbar()
    print_debug("Enjin Plugin Enabled!")

func _exit_tree():
    remove_from_toolbar()
    disconnect("resource_saved", self, "resource_saved_listener")
    print_debug("Enjin Plugin Disabled!")

# Reload the toolbar
func reload_toolbar():
    remove_from_toolbar()
    add_to_toolbar()

# Disable and re-enable the plugin (mostly serves as a hot-reload fix)
func reload_plugin():
    var editor_interface: EditorInterface = get_editor_interface()
    editor_interface.set_plugin_enabled(directory_name, false)
    editor_interface.set_plugin_enabled(directory_name, true)

# Add the plugin toolbar to the editor toolbar
func add_to_toolbar():
    if editor_toolbar == null:
        return
    toolbar = toolbar_tscn.instance()
    toolbar.set_plugin(self)
    editor_toolbar.add_child(toolbar, true)

# Remove the plugin toolbar from the editor toolbar
func remove_from_toolbar():
    if toolbar == null:
        return
    editor_toolbar.remove_child(toolbar)
    toolbar.queue_free()
    toolbar = null

# Removes orphaned nodes created by the plugin
func remove_orphans(node: Node):
    for child in node.get_children():
        if (child.text != "Enjin"):
            continue
        node.remove_child(child)
        child.queue_free()

# Reloads the plugin if any scripts are saved
func resource_saved_listener(ref: Resource):
    var path = ref.resource_path
    if "res://addons/enjin/" in path and ".gd" in path:
        reload_plugin()