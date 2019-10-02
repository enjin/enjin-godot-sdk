tool
extends EditorPlugin

var toolbar_tscn = preload("res://addons/enjin/toolbar.tscn")
var toolbar = null

func _enter_tree():
	reload_toolbar()
	
func reload_toolbar():
	if toolbar != null:
		remove_control_from_container(CONTAINER_TOOLBAR, toolbar)
	toolbar = toolbar_tscn.instance()
	toolbar.get_node("enjin_menu").connect("pressed", self, "start_plugin")
	add_control_to_container(CONTAINER_TOOLBAR, toolbar)

func _exit_tree():
	remove_control_from_container(CONTAINER_TOOLBAR, toolbar)
	toolbar.queue_free()
	toolbar = null

func start_plugin():
	print("Plugin Started")