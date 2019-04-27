extends "res://addons/enjin/graphql.gd"

var helper
var enjin_api
var enjinObj
var references

var edit_app = false
var logged_in = false
var editedAppOldName = ""

### AVAILABLE PLATFORMS | ORDERED WITH PLATFORMS OPT BUTTON
var PLATFORMS = ["https://master.cloud.enjin.dev/","https://kovan.cloud.enjin.io","https://cloud.enjin.io/"]

class NodesReferences:
	var popup
	var nodes = {}
	
	func _init(_popup):
		popup = _popup
		nodes["tabs"] = popup.get_node("tabs")
		nodes["settings.opt"] = popup.get_node("tabs/Settings/p/c/opt")
		nodes["new.user.roles"] = popup.get_node("tabs/Team/dialog/grid/role/opt")
		nodes["login.anim"] = popup.get_node("tabs/Home/login_p/anim")
		nodes["user.apps"] = popup.get_node("tabs/Home/login_p/user/logged_in/apps")
		nodes["platform.url"] = popup.get_node("tabs/Home/login_p/user/platform/val")
		nodes["user.email"] = popup.get_node("tabs/Home/login_p/user/name/val")
		nodes["user.pass"] = popup.get_node("tabs/Home/login_p/user/password/val")
		nodes["logged.user"] = popup.get_node("tabs/Home/login_p/user/logged_in/username/val")
		nodes["logged.TP"] = popup.get_node("tabs/Home/login_p/user/logged_in/TP/val")
		nodes["create.app.name"] = popup.get_node("tabs/Home/login_p/user/create_app/name/val")
		nodes["create.app.icon"] = popup.get_node("tabs/Home/login_p/user/create_app/icon/val")
		nodes["create.app.description"] = popup.get_node("tabs/Home/login_p/user/create_app/description/val")
		nodes["mint.token.opt"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/select/opt")
		nodes["news.template"] = popup.get_parent().get_node("news_template")
		nodes["news.data"] = popup.get_node("tabs/Home/news_p/sc/data")

##### HOME PANEL SIGNALS [BTN,SIGNAL,FUNCTION_NAME]
var buttons = [["tabs/Home/login_p/user/btn/sign_up","pressed","on_sign_up"],
			   ["tabs/Home/login_p/user/btn/login","pressed","on_login"],
			   ["tabs/Home/login_p/user/create_app/btns/cancel","pressed","on_cancel_create_app"],
			   ["tabs/Home/login_p/user/create_app/btns/create","pressed","on_create_app"],
			   ["tabs/Home/login_p/forgot_pass_btn","pressed","on_forgot_password"],
			   ["tabs/Home/login_p/user/logged_in/btns/create_app","pressed","on_create_dialog_app"],
			   ["tabs/Home/login_p/user/logged_in/btns/edit_app","pressed","on_edit_app_dialog"],
			   ["tabs/Home/support_p/btns/website","pressed","on_website"],
			   ["tabs/Home/support_p/btns/support","pressed","on_support"],
			   ["tabs/Home/support_p/btns/k_base","pressed","on_k_base"],
			   ["tabs/Home/support_p/btns/forums","pressed","on_forums"],
			   ["tabs/Home/login_p/user/logged_in/log_out","pressed","on_logout"],
			   ["tabs/Home/login_p/user/platforms","item_selected","set_platform"],
			   ["tabs/Home/login_p/user/logged_in/apps","item_selected","set_current_app"]]

var default_options = [["tabs/Home/login_p/user/platforms", "Kovan Testnet"],
					   ["tabs/Home/login_p/user/platforms", "Kovan Production"],
					   ["tabs/Home/login_p/user/platforms", "EnjinX Platform"]]

func _ready():
	pass

func _init(plugin, main):
	self.helper = main.helper
	self.references = NodesReferences.new(plugin.get_node("popup"))
	self.enjin_api = main.enjin_api
	self.enjinObj = main.enjin_api.obj
	
	for btn in buttons:
		references.popup.get_node(btn[0]).connect(btn[1], self, btn[2])
	
	for btn in default_options:
		self.references.popup.get_node(btn[0]).add_item(btn[1])
	
	enjin_api.get_news(self,enjin_api.event.GET_NEWS)

func node(name):
	return references.nodes[name]

func update(e):
	match e:
		enjin_api.event.CREATE_IDENTITY:
			if enjinObj.current_identity == null:
				printt("error - something went wrong")
		
		enjin_api.event.CREATE_USER:
			printt("Response : ", enjinObj.users)
		
		enjin_api.event.CREATE_APP, enjin_api.event.EDIT_APP:
			update_apps()
			return
		
		enjin_api.event.LOGIN:
			if enjinObj.current_user != null:
				logged_in("success")
				if enjinObj.current_identity == null:
					enjin_api.request(CreateEnjinIdentity.new(enjinObj.current_user["id"]).query,
									  self,
									  enjin_api.event.CREATE_IDENTITY)
					return
			else:
				logged_in("failed")
				return
		
		enjin_api.event.GET_ROLES:
			if enjinObj.roles.keys().size() > 0:
				for role in enjinObj.roles.keys():
					if role != enjinObj.current_user["role_name"]: ##### DEFAULT ROLE !!
						node("settings.opt").add_item(role)
					
					node("new.user.roles").add_item(role)
				
				if node("new.user.roles").get_item_count() <= 0:
					node("new.user.roles").disabled = true
					node("new.user.roles").text = ""
				else:
					node("new.user.roles").select(0)
					node("new.user.roles").emit_signal("item_selected",0)
					node("new.user.roles").text = node("new.user.roles").get_item_text(0)
				
				if node("settings.opt").get_item_count() > 1:
					helper.hide_and_show([],["tabs/Settings/p/c/opt"])
			
			helper.hide_and_show(["tabs/Home/login_p/user/connecting"],[])
			node("login.anim").stop()
	
	if logged_in:
		return
	
	if node("login.anim").current_animation == "fetching":
		return
	
	set_up_apps()
	
	logged_in = true
	
	for i in range(2):
		node("tabs").set_tab_disabled(node("tabs").get_tab_count() - 1 - i,false)

func set_news(news_list):
	for news in news_list:
		var bb_code = "[b][color=grey]{text}[/color][/b]"  
		var template = node("news.template").duplicate()
		
		template.get_node("title").bbcode_text = bb_code.replace("{text}",news["title"])
		template.get_node("desc").text = news["description"]
		template.get_node("btn").connect("pressed",self,"on_read_more",[news["link"]])
		template.show()
		
		node("news.data").add_child(template)

func on_read_more(link):
	OS.shell_open(link)

func set_up_apps():
	if enjinObj.current_user["apps"].size() == 0:
		node("login.anim").play("login_success_without_apps")
	else:
		node("login.anim").play("login_success_with_apps")
		for app_name in enjinObj.current_user["apps"].keys():
			node("user.apps").add_item(app_name)
			node("mint.token.opt").add_item(app_name)
		
		helper.set_app(0)

func update_apps():
	node("login.anim").play("login_success_with_apps")
	if edit_app:
		var idx = -1
		for i in range(node("user.apps").get_item_count()):
			if editedAppOldName == node("user.apps").get_item_text(i):
				idx = i
				break
		
		if idx != -1:
			node("user.apps").set_item_text(idx, enjinObj.current_app)
			node("mint.token.opt").set_item_text(idx, enjinObj.current_app)
			helper.set_app(idx)
			node("user.apps").update()
			node("mint.token.opt").update()
	else:
		if enjinObj.platform_apps.empty():
			return
		
		var last = enjinObj.platform_apps.back()
		if last:
			node("user.apps").add_item(last["name"])
			node("mint.token.opt").add_item(last["name"])
			node("user.apps").select(node("user.apps").get_item_count() - 1)
			node("user.apps").emit_signal("item_selected",node("user.apps").get_item_count() - 1)

func on_sign_up():
	OS.shell_open("https://"+enjin_api.url+"/#/signup")

func on_forgot_password():
	OS.shell_open("https://"+enjin_api.url+"/#/reset")

func on_login():
	enjin_api.create_client(node("platform.url").text)
	var email = node("user.email").text
	var passwd = node("user.pass").text
	
	enjin_api.request(EnjinOauth.new(email,passwd).query,
					  self,
					  enjin_api.event.LOGIN)
	node("login.anim").play("logging_in")

func clear():
	self.enjinObj = enjin_api.obj
	var apps = node("user.apps")
	for i in range(apps.get_item_count()-1,-1,-1):
		apps.remove_item(i)

func on_logout():
	enjin_api.log_out()
	helper.clear()
	logged_in = false
	
	for i in range(1,node("tabs").get_child_count()):
		node("tabs").set_tab_disabled(i,true)
	
	node("user.pass").text = ""
	logged_in("failed")

func logged_in(status):
	if status == "success":
		node("logged.user").text = enjinObj.current_user["user"]
		node("logged.TP").text = "https://" + enjin_api.url
		fetch_data()
	elif status == "failed":
		node("login.anim").play("login_failed")

func fetch_data(switch_app = false):
	if switch_app:
		pass
		#node("login.anim").play("switch_app")
	else:
		node("login.anim").play("fetching")
	
	enjin_api.request(EnjinRoles.new().query,
					  self,
					  enjin_api.event.GET_ROLES)

func on_create_app():
	var name = node("create.app.name").text
	var description = node("create.app.description").text
	var icon = node("create.app.icon").text
	
	var appQuery
	var event
	
	if !edit_app:
		appQuery = CreateEnjinApp.new(name,icon,description)
		event = enjin_api.event.CREATE_APP
	else:
		appQuery = EditEnjinApp.new(name,icon,description)
		event = enjin_api.event.EDIT_APP
	
	if appQuery.error:
		helper.error(event,appQuery.error,"finished_with_error")
		return
	
	enjin_api.request(appQuery.query,
					  self,
					  event)

func on_create_dialog_app():
	node("login.anim").play("create_app")

func on_edit_app_dialog():
	node("login.anim").play("edit_app")
	edit_app = true
	editedAppOldName = enjinObj.current_app
	for app in enjinObj.platform_apps:
		if app["name"] == enjinObj.current_app:
			node("create.app.name").text = app["name"]
			node("create.app.icon").text = app["image"]
			node("create.app.description").text = app["description"]
			return

func on_cancel_create_app():
	edit_app = false
	if enjinObj.current_user["apps"].size() == 0:
		node("login.anim").play("login_success_without_apps")
	else:
		node("login.anim").play("login_success_with_apps")

func set_platform(ID):
	node("platform.url").text = PLATFORMS[ID]
	enjin_api.create_client(node("platform.url").text)

func set_current_app(ID):
	enjinObj.change_role(ID)
	helper.set_app(ID,true)

func on_website():
	OS.shell_open("https://"+enjin_api.url+"/")

func on_support():
	OS.shell_open("https://"+enjin_api.url+"/")

func on_k_base():
	OS.shell_open("https://"+enjin_api.url+"/")

func on_forums():
	OS.shell_open("https://"+enjin_api.url+"/")
