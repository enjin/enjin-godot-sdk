extends "res://addons/enjin/graphql.gd"

var searchable = SEARCHABLE.DEFAULT
var helper
var enjin_api
var enjinObj

var references 

class NodesReferences:
	var popup
	var nodes = {}
	
	func _init(_popup):
		popup = _popup
		nodes["search.value"] = popup.get_node("tabs/Team/top_panel/search_panel/val")
		nodes["team.data"] = popup.get_node("tabs/Team/p/sc/data")
		nodes["dialog.user.role"] = popup.get_node("tabs/Team/dialog/grid/role/opt")
		nodes["create.user.btn"] = popup.get_node("tabs/Team/top_panel/u_panel/btns/create_user")
		nodes["invite.user.btn"] = popup.get_node("tabs/Team/top_panel/u_panel/btns/invite_user")
		nodes["user.email"] = popup.get_node("tabs/Team/dialog/grid/email/val")
		nodes["user.name"] = popup.get_node("tabs/Team/dialog/grid/username/val")
		nodes["user.password-identity"] = popup.get_node("tabs/Team/dialog/grid/password-identity_id/val")
		nodes["panel.anim"] = popup.get_node("tabs/Team/anim")

var user = ["id","role_name","identity_id","name","email"]

var selected_user = null
var selected_role = ""
var _event = 0 ##### CURRENT EVENT - USER CREATE | DELETE | EDIT

##### TEAM PANEL SIGNALS [BTN,SIGNAL,FUNCTION_NAME]
var buttons = [["tabs/Team/top_panel/u_panel/btns/create_user","pressed","on_open_create_user_dialog"],
			   ["tabs/Team/top_panel/u_panel/btns/invite_user","pressed","on_open_invite_user_dialog"],
			   ["tabs/Team/dialog/close","pressed","on_close_create_user_dialog"],
			   ["tabs/Team/dialog/grid/btns/cancel","pressed","on_close_create_user_dialog"],
			   ["tabs/Team/dialog/grid/btns/create_user","pressed","on_create_user"],
			   ["tabs/Team/dialog/grid/btns/invite_user","pressed","on_invite_user"],
			   ["tabs/Team/top_panel/search_panel/search_btn", "pressed","search"],
			   ["tabs/Team/top_panel/search_panel/opt", "item_selected","on_search_opt_selected"],
			   ["tabs/Team/dialog/grid/role/opt", "item_selected","on_role_selected"],
			   ["tabs","tab_selected","selected"]]

##### OPTIONS BUTTONS DEFAULT VALUES [BTN,VALUE]
var default_options = [["tabs/Team/top_panel/search_panel/opt", "All"],
					   ["tabs/Team/top_panel/search_panel/opt", "User ID"],
					   ["tabs/Team/top_panel/search_panel/opt", "Username"],
					   ["tabs/Team/top_panel/search_panel/opt", "Email"]]

func _ready():
	pass

func _init(plugin, main):
	self.helper = main.helper
	self.references = NodesReferences.new(plugin.get_node("popup"))
	self.enjin_api = main.enjin_api
	self.enjinObj = main.enjin_api.obj
	
	for btn in buttons:
		self.references.popup.get_node(btn[0]).connect(btn[1], self, btn[2])
		
	for btn in default_options:
		self.references.popup.get_node(btn[0]).add_item(btn[1])

func node(name):
	return references.nodes[name]

func update(e):
	match e:
		enjin_api.event.GET_TEAM:
			var set = [0,enjinObj.team.size(),user,enjinObj.team]
			helper.populate_rows("user_template",
								 "tabs/Team/p/sc/data",
								 set,
								 true,
								 self)
			helper.setup_navigation_bar("tabs/Team/p/nav",
										enjinObj.team.size(),
										self)
		
		enjin_api.event.CREATE_USER, enjin_api.event.UPDATE_USER, enjin_api.event.DELETE_USER:
			print(enjinObj.team)
			helper.update_navigation_bar("tabs/Team/p/nav",
										 enjinObj.team.size(),
										 self)

func search():
	enjinObj.team = []
	clear(false)
	helper.clear_navs(1)
	var value = node("search.value").text
	
	enjin_api.request(EnjinUsers.new(value,searchable).query,
					  self,
					  enjin_api.event.GET_TEAM)

func delete(id):
	enjin_api.request(DeleteEnjinUser.new(id).query,
					  self,
					  enjin_api.event.DELETE_USER)

func clear(logout=true):
	self.enjinObj = enjin_api.obj
	for n in node("team.data").get_children():
		n.queue_free()
	
	on_close_create_user_dialog()
	
	if !logout:
		return
	
	var user_roles = node("dialog.user.role")
	for i in range(user_roles.get_item_count()-1,-1,-1):
		user_roles.remove_item(i)
	
	node("create.user.btn").disabled = false
	node("invite.user.btn").disabled = false

func deferred_populate(set):
	set.append(user)
	set.append(enjinObj.team)
	
	helper.populate_rows("user_template",
						 "tabs/Team/p/sc/data",
						 set,
						 false,
						 self)

func selected(tab):
	if tab == 3:
		if !enjinObj.role.has("manageUsers"):
			node("create.user.btn").disabled = true
			node("invite.user.btn").disabled = true
		
		if enjinObj.team.size() == 0:
			enjin_api.request(EnjinUsers.new().query,
							  self,
							  enjin_api.event.GET_TEAM)

func on_search_opt_selected(ID):
	if ID == 0:
		searchable = SEARCHABLE.DEFAULT
	elif ID == 1:
		searchable = SEARCHABLE.BYID
	elif ID == 2:
		searchable = SEARCHABLE.BYNAME
	elif ID == 3:
		searchable = SEARCHABLE.BYEMAIL

func on_create_user():
	var data = {"app_id":enjinObj.current_user["apps"][enjinObj.current_app]["id"],
				"email":node("user.email").text,
				"username":node("user.name").text,
				"role":selected_role}
	
	match _event:
		enjin_api.event.CREATE_USER:
			data["password"] = node("user.password-identity").text
			var createUser = CreateEnjinUser.new(data)
			
			if createUser.error:
				helper.error(_event,createUser.error,"finished_with_error")
				return
			
			enjin_api.request(createUser.query,
							  self,
							  _event)
		
		enjin_api.event.UPDATE_USER:
			var updateUser = UpdateEnjinUser.new(selected_user["id"],
												 data["username"],
												 data["email"],
												 node("user.password-identity").text,
												 data["role"])
			
			enjin_api.request(updateUser.query,
							  self,
							  _event)

func on_invite_user():
	pass

func on_open_create_user_dialog():
	node("panel.anim").play("create_user")
	_event = enjin_api.event.CREATE_USER

func on_close_create_user_dialog():
	node("panel.anim").play("cancel")

func on_open_invite_user_dialog():
	node("panel.anim").play("invite_user")

func manage_buttons(node, edible):
	if !enjinObj.role.has("manageUsers"):
		node.get_node("buttons/edit_btn").hide()
	
	if node.get_node("c2").text == "Platform Owner":
		node.get_node("buttons/delete_btn").hide()
		node.get_node("buttons/sep").hide()
		node.get_node("buttons/edit_btn").hide()
	
	if !enjinObj.role.has("deleteUsers") or node.get_node("c5").text == enjinObj.current_user["email"]:
		node.get_node("buttons/delete_btn").hide()
		node.get_node("buttons/sep").hide()

func on_role_selected(ID):
	selected_role = node("dialog.user.role").get_item_text(ID)

func on_edit_btn(btn,data):
	_event = enjin_api.event.UPDATE_USER
	
	node("user.email").text = data["email"]
	node("user.name").text = data["name"]
	
	selected_user = data
	node("panel.anim").play("edit_user")

func on_delete_btn(btn,data):
	var message = "Are you sure you want to delete User(id:"+str(data["id"])+"): "+data["name"]+" ?"
	helper.delete_item(self,message,data["id"])