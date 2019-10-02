tool
extends EditorPlugin

const toolbar_path_1_3_1 = "/root/EditorNode/@@5/@@6/@@14/@@15/@@54/"
const toolbar_menus = [ "Scene", "Project", "Debug", "Editor", "Help" ]

var toolbar_tscn = preload("res://addons/enjin/toolbar.tscn")
var primary_toolbar : Node = null
var toolbar = null

func _enter_tree():
	if toolbar == null:
		var base_control = get_editor_interface().get_base_control();
		var toolbar_node = find_scene_menu_quick(base_control)
		
		if toolbar_node is HBoxContainer == false:
			toolbar_node = find_scene_menu(base_control)	
			
		if toolbar_node is HBoxContainer:
			primary_toolbar = toolbar_node
	
	reload_toolbar()

func find_scene_menu_quick(node: Node):
	var result = get_node(NodePath(toolbar_path_1_3_1))
	
	if is_primary_toolbar(result):
		return result
		
	return false
	
func is_primary_toolbar(node: Node):
	if node is HBoxContainer == false:
		return false
		
	var button_texts = {}
	for child in node.get_children():
		if child is MenuButton:
			button_texts[child.text] = child.text
	
	return button_texts.has_all(toolbar_menus)

func find_scene_menu(node: Node):	
	if is_primary_toolbar(node):
		return node
	
	if node.get_child_count() > 0:
		for child in node.get_children():
			var result = find_scene_menu(child as Node)
			if result:
				return result
	
	return false
	
func reload_toolbar():
	if toolbar != null:
		remove_control_from_container(CONTAINER_TOOLBAR, toolbar)
	if primary_toolbar == null:
		return
		
	toolbar = toolbar_tscn.instance()
	toolbar.connect("pressed", self, "start_plugin")
	
	primary_toolbar.add_child(toolbar, true)
	
#	add_control_to_container(CONTAINER_TOOLBAR, toolbar)

func _exit_tree():
	primary_toolbar.remove_child(toolbar)
	
#	remove_control_from_container(CONTAINER_TOOLBAR, toolbar)

	toolbar.queue_free()
	toolbar = null

func start_plugin():
	print("Plugin Started")