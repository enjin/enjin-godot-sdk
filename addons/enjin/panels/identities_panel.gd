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
		nodes["tabs"] = popup.get_node("tabs")
		nodes["search.value"] = popup.get_node("tabs/Identities/top_panel/search_panel/val")
		nodes["identities.data"] = popup.get_node("tabs/Identities/p/sc/data")
		nodes["on.new.identity"] = popup.get_node("tabs/Identities/top_panel/i_panel/open_i_btn")
		nodes["user.id"] = popup.get_node("tabs/Identities/dialog/grid/user_id/val")
		nodes["eth.address"] = popup.get_node("tabs/Identities/dialog/grid/eth_address/val")
		nodes["panel.anim"] = popup.get_node("tabs/Identities/anim")

var identity = ["id",["user","id"],"linking_code","ethereum_address"]
var _event = 0 ###### CURRENT EVENT - IDENTITY CREATE | DELETE | UPDATE
var selected_identity = null

##### IDENTITIES PANEL SIGNALS [BTN,SIGNAL,FUNCTION_NAME]
var buttons = [["tabs/Identities/top_panel/i_panel/open_i_btn", "pressed", "on_open_create_identity_dialog"],
			   ["tabs/Identities/dialog/close", "pressed","on_close_create_identity_dialog"],
			   ["tabs/Identities/dialog/grid/btns/cancel", "pressed","on_close_create_identity_dialog"],
			   ["tabs/Identities/dialog/grid/btns/create_identity", "pressed","on_create_identity"],
			   ["tabs/Identities/top_panel/search_panel/opt", "item_selected","on_search_opt_selected"],
			   ["tabs/Identities/top_panel/search_panel/search_btn", "pressed","search"],
			   ["tabs","tab_selected","selected"]]

##### OPTIONS BUTTONS DEFAULT VALUES [BTN,VALUE]
var default_options = [["tabs/Identities/top_panel/search_panel/opt", "All"],
					   ["tabs/Identities/top_panel/search_panel/opt", "Identity ID"],
					   ["tabs/Identities/top_panel/search_panel/opt", "Ethereum Address"],
					   ["tabs/Identities/top_panel/search_panel/opt", "Linking Code"]]

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
		enjin_api.event.GET_IDENTITIES:
			var set = [0,enjinObj.identities.size(),identity,enjinObj.identities]
			helper.populate_rows("identity_template",
								 "tabs/Identities/p/sc/data",
								 set,
								 true,
								 self)
			helper.setup_navigation_bar("tabs/Identities/p/nav",
										enjinObj.identities.size(),
										self)
		
		enjin_api.event.CREATE_IDENTITY, enjin_api.event.UPDATE_IDENTITY, enjin_api.event.DELETE_IDENTITY:
			helper.update_navigation_bar("tabs/Identities/p/nav",
										 enjinObj.identities.size(),
										 self) 

func search():
	enjinObj.identities = []
	clear(false)
	helper.clear_navs(2)
	
	enjin_api.request(EnjinIdentities.new(node("search.value").text,searchable).query,
					  self,
					  enjin_api.event.GET_IDENTITIES)

func delete(id):
	enjin_api.request(DeleteEnjinIdentity.new(id).query,
					  self,
					  enjin_api.event.DELETE_IDENTITY)

func clear(logout = true):
	self.enjinObj = enjin_api.obj
	for n in node("identities.data").get_children():
		n.queue_free()
	
	on_close_create_identity_dialog()
	
	if !logout:
		return
	
	node("on.new.identity").disabled = false


func deferred_populate(set):
	set.append(identity)
	set.append(enjinObj.identities)
	
	helper.populate_rows("identity_template",
						 "tabs/Identities/p/sc/data",
						 set,
						 false,
						 self)

func selected(tab):
	if tab == 2:
		if !enjinObj.role.has("manageIdentities"):
			node("on.new.identity").disabled = true
			
		if enjinObj.identities.size() == 0:
			enjin_api.request(EnjinIdentities.new().query,
							  self,
							  enjin_api.event.GET_IDENTITIES)

func on_search_opt_selected(ID):
	if ID == 0:
		searchable = SEARCHABLE.DEFAULT
	elif ID == 1:
		searchable = SEARCHABLE.BYID
	elif ID == 2:
		searchable = SEARCHABLE.BYADDRESS
	elif ID == 3:
		searchable = SEARCHABLE.BYLINKINGCODE

func on_create_identity():
	match _event:
		enjin_api.event.CREATE_IDENTITY:
			var createIdentity = CreateEnjinIdentity.new(node("user.id").text,
														 node("eth.address").text)
			
			if createIdentity.error:
				helper.error(_event,createIdentity.error,"finished_with_error")
				return
			
			enjin_api.request(createIdentity.query,
							  self,
							  _event)
		
		enjin_api.event.UPDATE_IDENTITY:
			var l_code = selected_identity["linking_code"] if selected_identity["linking_code"] != "Linked" else ""
			var updateIdentity = UpdateEnjinIdentity.new(selected_identity["id"],
														 node("user.id").text,
														 l_code,
														 node("eth.address").text)
			
			enjin_api.request(updateIdentity.query,
							  self,
							  _event)

func on_open_create_identity_dialog():
	node("panel.anim").play("create_identity")
	_event = enjin_api.event.CREATE_IDENTITY

func on_close_create_identity_dialog():
	node("panel.anim").play("cancel")

func manage_buttons(node, edible):
	if node.get_node("c1").text == str(enjinObj.current_identity["id"]):
		node.get_node("buttons/edit_btn").text = "Unlink"
		node.get_node("buttons/sep").hide()
		node.get_node("buttons/delete_btn").hide()
		return
	
	if node.get_node("c2").text == "1":
		node.get_node("buttons/delete_btn").hide()
		node.get_node("buttons/sep").hide()
		node.get_node("buttons/edit_btn").hide()
	
	if !enjinObj.role.has("manageIdentities"):
		node.get_node("buttons/edit_btn").hide()
		node.get_node("buttons/sep").hide()
	
	if !enjinObj.role.has("deleteIdentities"):
		node.get_node("buttons/delete_btn").hide()
		node.get_node("buttons/sep").hide()

func on_edit_btn(btn,data):
	if btn.text == "Unlink":
		node("tabs").current_tab = 4
		return
	
	if data["user"] != null:
		node("user.id").text = str(data["user"]["id"])
	
	if data["ethereum_address"] != null:
		node("eth.address").text = data["ethereum_address"]
	
	node("panel.anim").play("update_identity")
	_event = enjin_api.event.UPDATE_IDENTITY
	selected_identity = data

func on_delete_btn(btn,data):
	var message = "Are you sure you want to delete Identity(id:"+str(data["id"])+") ?"
	helper.delete_item(self,message,data["id"])