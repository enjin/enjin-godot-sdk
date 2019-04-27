extends Control

var MAX_ROW_SIZE = 25
var popup
var enjin
var main

var delete_event = null # [panel, item_id]

func _ready():
	pass

func _init(_enjin, _main):
	self.main = _main
	self.enjin = _enjin
	self.popup = _enjin.get_node("popup")
	
	popup.get_node("bg/p2/close").connect("pressed",self,"close_loading")
	popup.get_node("bg/confirm").connect("pressed",self,"on_delete_item")

func hide_and_show(nodes_to_hide, nodes_to_show):
	for n in nodes_to_hide:
		if popup.get_node(n).visible:
			popup.get_node(n).hide()
			
	for n in nodes_to_show:
		if !popup.get_node(n).visible:
			popup.get_node(n).show()

func loading(event, anim):
	var home_events = [main.enjin_api.event.LOGIN,
					   main.enjin_api.event.GET_ROLES]
	
	if !home_events.has(event):
		popup.get_node("bg").get_node("anim").play(anim)

func error(event,error,anim,obj = null):
	var home_events = [main.enjin_api.event.LOGIN,
					   main.enjin_api.event.GET_ROLES]
	
	if home_events.has(event) and main.enjin_api.obj.current_user == null:
		obj.call_deferred("logged_in","failed")
		
	popup.get_node("bg").get_node("error").text = error
	popup.get_node("bg").get_node("anim").play(anim)

func delete_item(panel, message, item_id):
	popup.get_node("bg").get_node("delete").text = message
	popup.get_node("bg").get_node("anim").play("delete_item")
	delete_event = [panel,item_id]

func on_delete_item():
	if delete_event == null:
		return
	
	delete_event[0].call_deferred("delete",delete_event[1])

func close_loading():
	popup.get_node("bg").get_node("anim").play("close")

func clear():
	#############################
	# CLEAR PANELS AFTER LOGOUT #
	#############################
	if !main.panels:
		return
	
	clear_navs()
	
	main.panels.home.call_deferred("clear")
	main.panels.team.call_deferred("clear")
	main.panels.identities.call_deferred("clear")
	main.panels.tokens.call_deferred("clear")
	main.panels.wallet.call_deferred("clear")
	main.panels.settings.call_deferred("clear")

func clear_navs(nav=null):
	var navs = ["tabs/Cryptoitems/p/nav","tabs/Team/p/nav","tabs/Identities/p/nav"]
	
	if nav:
		navs = [navs[nav]]
	
	for nav in navs:
		for n in popup.get_node(nav).get_children():
			if n.text == "<<":
				if n.is_connected("pressed",self,"on_prev_btn"):
					n.disconnect("pressed",self,"on_prev_btn")
			elif n.text == "1":
				if n.is_connected("pressed",self,"on_list_btn"):
					n.disconnect("pressed",self,"on_list_btn")
			elif n.text == ">>":
				if n.is_connected("pressed",self,"on_next_btn"):
					n.disconnect("pressed",self,"on_next_btn")
			else:
				n.queue_free()
			
		popup.get_node(nav).set_anchors_and_margins_preset(Control.PRESET_BOTTOM_RIGHT)


func set_app(ID, s=false):
	############################################################################
	# UNLINK CURRENT IDENTITY AND SWITCH TO THE ONE RELATED TO THE CURRENT APP #
	############################################################################
	var nodes = {"mint_token_opt":popup.get_node("tabs/Cryptoitems/p/mint_token/grid/select/opt"),
				 "user_apps":popup.get_node("tabs/Home/login_p/user/logged_in/apps"),
				 "new_identity_app":popup.get_node("tabs/Identities/dialog/grid/app_name"),
				 "new_identity_app_id":popup.get_node("tabs/Identities/dialog/grid/app_id")}
	
	var obj = main.enjin_api.obj
	nodes["mint_token_opt"].select(ID + 1)
	obj.current_app = nodes["user_apps"].get_item_text(ID)
	print(obj.current_user)
	print(obj.role)
	print(obj.roles)
	nodes["new_identity_app"].text = obj.current_app
	nodes["new_identity_app_id"].text = "APPLICATION ID("+str(obj.current_user["apps"][obj.current_app]["id"])+")"
	
	if !obj.check_identity():
		#main.enjin_api.request(CreateEnjinIdentity.new(enjinObj.current_user["id"]).query,
		#				  main.panels.wallet,
		#				  enjin_api.event.CREATE_IDENTITY)
		pass
	else:
		if obj.current_identity["ethereum_address"] != null:
			main.panels.wallet.link(false)
		else:
			main.panels.wallet.unlink(false)
	
	main.enjin_api.update_bearer()
	if s:
		switch_app()

func switch_app():
	main.enjin_api.obj.team = []
	main.enjin_api.obj.identities = []
	main.enjin_api.obj.tokens = []
	main.enjin_api.obj.roles.clear()
	
	main.panels.team.call_deferred("clear")
	main.panels.identities.call_deferred("clear")
	main.panels.tokens.call_deferred("clear", false)
	clear_navs()
	
	main.panels.settings.call_deferred("clear")
	main.panels.home.call_deferred("fetch_data", true)

func populate_rows(template, parent, set, create = true, obj = null):
	if set.size() != 4:
		print("Invalid SET !!! Must be : [row_start_num, row_end_num, cols, data]") 
		return
		
	var row_start = set[0] ## Starting value for the Rows
	var row_end = set[1] ## Last row value
	var cols = set[2] ## Table columns // ORDERED
	
	### Columns must not exceed template size
	if cols.size() > enjin.get_node(template).get_child_count() - 1:
		print("invalid columns size !!")
		return
	
	### Max rows to display in table
	if create:
		if row_end >= MAX_ROW_SIZE:
			row_end = MAX_ROW_SIZE
			
		for i in range(MAX_ROW_SIZE):
			popup.get_node(parent).add_child(enjin.get_node(template).duplicate())
			
	elif row_end - row_start < MAX_ROW_SIZE:
		for i in range(MAX_ROW_SIZE):
			if i >= row_end - row_start:
				if popup.get_node(parent).get_child(i).visible:
					popup.get_node(parent).get_child(i).hide()
			else:
				if !popup.get_node(parent).get_child(i).visible:
					popup.get_node(parent).get_child(i).show()
	else:
		for n in popup.get_node(parent).get_children():
			if !n.visible:
				n.show()
	
	var aux_i = 0
	for i in range(row_start,row_end):
		var data = set[3][i] ## Table data !!
		var node = popup.get_node(parent).get_child(aux_i)
		aux_i += 1
		
		if template.find("token") != -1:
			node.name = "token_" + str(i)
		elif template.find("identity") != -1:
			node.name = "identity_" + str(i)
		elif template.find("user") != -1:
			node.name = "user_" + str(i)
		
		var child_idx = 0
		for c in cols:
			var n = node.get_child(child_idx)
			if typeof(c) == TYPE_ARRAY:
				var last = false
				var z = 0
				var aux = data
				while !last:
					if !aux.has(c[z]):
						break
					
					aux = aux[c[z]]
					
					if !aux:
						##print("value {", c[z], "} in Dictionary[", data,"] is null")
						n.text = ""
						break
					
					if typeof(aux) != TYPE_DICTIONARY:
						n.text = str(aux)
						last = true
						
					z+=1
			elif typeof(c) == TYPE_STRING and c != "":
				if data.has(c) and data[c] != null:
						n.text = str(data[c])
				else:
					n.text = ""
					
			child_idx+=1
		
		if create:
			node.show()
			
		if obj == null:
			return
			
		if !node.has_node("buttons"):
			printt("Invalid not. Required Path : root://enjin/identity_template" +
				   " found " + node.get_path())
			return
	
		for btn in node.get_node("buttons").get_children():
			if !btn.is_class("Button"):
				pass
			elif !btn.is_connected("pressed",obj,"on_"+btn.name):
				btn.connect("pressed",obj,"on_"+btn.name,[btn,data])
			elif btn.is_connected("pressed",obj,"on_"+btn.name):
				btn.disconnect("pressed",obj,"on_"+btn.name)
				btn.connect("pressed",obj,"on_"+btn.name,[btn,data])
		
		var edible = null
		if data.has("edible"):
			edible = data["edible"]
		
		obj.call_deferred("manage_buttons", node, edible)

func setup_navigation_bar(nav, x_rows, obj):
	##DEFAULT INIT
	popup.get_node(nav).get_child(0).connect("pressed",self,"on_prev_btn",[popup.get_node(nav)])
	popup.get_node(nav).get_child(1).connect("pressed",self,"on_list_btn",[0,MAX_ROW_SIZE,popup.get_node(nav).get_child(1),obj])
	popup.get_node(nav).get_child(1).disabled = true
	popup.get_node(nav).get_child(2).connect("pressed",self,"on_next_btn",[popup.get_node(nav)])
	
	var last_set = x_rows % MAX_ROW_SIZE
	var list_offset = 1
	
	if last_set != 0:
		list_offset += 1
		
	var n_items = int(x_rows / MAX_ROW_SIZE) + list_offset
	
	var l_btn = popup.get_node(nav).get_child(1) ### GET LIST 1 BTN - DEFAULT
	
	for i in range(2,n_items):
		var new_btn = l_btn.duplicate()
		new_btn.disabled = false
		var args = []
		if i == n_items - 1 and last_set > 0: ## IGNORE WHEN % IS 0
			 args = [MAX_ROW_SIZE * (i - 1), MAX_ROW_SIZE * (i - 1) + last_set]
		else:
			args = [MAX_ROW_SIZE * (i - 1), i * MAX_ROW_SIZE]
		
		args.append(new_btn)
		args.append(obj)
		new_btn.name += str(i)
		new_btn.text = str(i)
		new_btn.connect("pressed",self,"on_list_btn",args)
		popup.get_node(nav).add_child(new_btn)
		popup.get_node(nav).set_anchors_and_margins_preset(Control.PRESET_BOTTOM_RIGHT)
		
	popup.get_node(nav).move_child(popup.get_node(nav).get_child(2),
								   popup.get_node(nav).get_child_count()-1)

func update_navigation_bar(nav, x_rows, obj):
	var n_items = int(x_rows / MAX_ROW_SIZE)
	var count = popup.get_node(nav).get_child_count()
	
	if n_items + 2 == count and x_rows % MAX_ROW_SIZE == 1:
		var l_btn = popup.get_node(nav).get_child(1).duplicate()
		l_btn.name += str(count - 1)
		l_btn.text = str(count - 1)
		popup.get_node(nav).add_child(l_btn)
		count += 1
		popup.get_node(nav).set_anchors_and_margins_preset(Control.PRESET_BOTTOM_RIGHT)
		popup.get_node(nav).move_child(popup.get_node(nav).get_child(count - 2), count - 1)
	
	if popup.get_node(nav).get_child(count - 2).is_connected("pressed",self,"on_list_btn"):
		popup.get_node(nav).get_child(count - 2).disconnect("pressed",self,"on_list_btn")
	
	var args = []
	if (x_rows % MAX_ROW_SIZE)  > 0: ## IGNORE WHEN % IS 0
		n_items += 1
		args = [MAX_ROW_SIZE * (n_items - 1), MAX_ROW_SIZE * (n_items - 1) + (x_rows % MAX_ROW_SIZE)]
	else:
		args = [MAX_ROW_SIZE * (n_items - 1), n_items * MAX_ROW_SIZE]
	
	args.append(popup.get_node(nav).get_child(count - 2))
	args.append(obj)
	popup.get_node(nav).get_child(count - 2).connect("pressed",self,"on_list_btn",args)
	if popup.get_node(nav).get_child(count - 2).disabled:
		popup.get_node(nav).get_child(count - 2).emit_signal("pressed")

func on_prev_btn(nav):
	if nav.get_child_count() == 3:
		return ## DO NOTHING IF THERE IS ONLY 1 LIST
	
	for i in range(1,nav.get_child_count()):
		if nav.get_child(i).disabled:
			nav.get_child(i).disabled = false
			if i-1 < 1:
				nav.get_child(nav.get_child_count() - 2).emit_signal("pressed")
				nav.get_child(nav.get_child_count() - 2).disabled = true
				return
			else:
				nav.get_child(i-1).emit_signal("pressed")
				nav.get_child(i-1).disabled = true
				return

func on_next_btn(nav):
	if nav.get_child_count() == 3:
		return ## DO NOTHING IF THERE IS ONLY 1 LIST
		
	for i in range(1,nav.get_child_count()):
		if nav.get_child(i).disabled:
			nav.get_child(i).disabled = false
			if i+1 > nav.get_child_count() - 2:
				nav.get_child(1).emit_signal("pressed")
				nav.get_child(1).disabled = true
				return
			else:
				nav.get_child(i+1).emit_signal("pressed")
				nav.get_child(i+1).disabled = true
				return

func on_list_btn(row_start, row_end, btn, obj):
	obj.call_deferred("deferred_populate", [row_start, row_end])
	
	for n in btn.get_parent().get_children():
		if n.disabled:
			n.disabled = false
		
	btn.disabled = true