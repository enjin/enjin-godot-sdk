tool
extends EditorPlugin

# Class references
var EditorMenus = preload("res://addons/enjin/editor/extensions/EditorMenus.gd")
# Toolbar ui template
var toolbar_tscn = preload("res://addons/enjin/editor/toolbar.tscn")
# Editor's primary toolbar (e.g. Scene Project Debug Editor Help)
var editor_toolbar: Node = null
# Toolbar ui instance
var toolbar: Node = null

func _enter_tree():
    if editor_toolbar == null:
        editor_toolbar = EditorMenus.get_primary_toolbar(self)
    reload_toolbar()

func _exit_tree():
    remove_from_toolbar()

# Reload the toolbar
func reload_toolbar():
    remove_from_toolbar()
    add_to_toolbar()

# Add the plugin toolbar to the editor toolbar
func add_to_toolbar():
    if editor_toolbar == null:
        return
    toolbar = toolbar_tscn.instance()
    editor_toolbar.add_child(toolbar, true)

# Remove the plugin toolbar from the editor toolbar
func remove_from_toolbar():
    if toolbar == null:
        return
    editor_toolbar.remove_child(toolbar)
    toolbar.queue_free()
    toolbar = null

func start_plugin():
    print("Plugin Started")