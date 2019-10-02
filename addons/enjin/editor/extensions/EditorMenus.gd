const toolbar_path_1_3_1 = "/root/EditorNode/@@5/@@6/@@14/@@15/@@54/"
const toolbar_menus = [ "Scene", "Project", "Debug", "Editor", "Help" ]

static func get_primary_toolbar(plugin: EditorPlugin):
	var base_control = plugin.get_editor_interface().get_base_control();
	var toolbar_node = find_scene_menu_quick(base_control)
		
	if toolbar_node is HBoxContainer == false:
		toolbar_node = find_scene_menu(base_control)	
			
	if toolbar_node is HBoxContainer == false:
		return null
			
	return toolbar_node
			
static func is_primary_toolbar(node: Node):
	if node is HBoxContainer == false:
		return false
		
	var button_texts = {}
	for child in node.get_children():
		if child is MenuButton:
			button_texts[child.text] = child.text
	
	return button_texts.has_all(toolbar_menus)
			
static func find_scene_menu_quick(node: Node):
	var result = node.get_node(NodePath(toolbar_path_1_3_1))
	
	if is_primary_toolbar(result):
		return result
		
	return false

static func find_scene_menu(node: Node):	
	if is_primary_toolbar(node):
		return node
	
	if node.get_child_count() > 0:
		for child in node.get_children():
			var result = find_scene_menu(child as Node)
			if result:
				return result
	
	return false