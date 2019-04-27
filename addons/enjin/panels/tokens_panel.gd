extends "res://addons/enjin/graphql.gd"

var helper
var enjin_api
var enjinObj
var currentTokenId = ""
var transferToAddress = ""
var edit_token = false
var reserve_balance = 0
var reserve_enj_cost = 0

var references 

class NodesReferences:
	var popup
	var nodes = {}
	
	func _init(_popup):
		popup = _popup
		nodes["file.dialog"] = popup.get_node("tabs/Cryptoitems/p/mint_token/dialog_bg/file_dialog")
		nodes["search.value"] = popup.get_node("tabs/Cryptoitems/top_panel/search_panel/val")
		nodes["tokens.data"] = popup.get_node("tabs/Cryptoitems/p/sc/data")
		nodes["current.app"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/select/opt")
		nodes["open.mint.btn"] = popup.get_node("tabs/Cryptoitems/top_panel/mint_panel/open_t_btn")
		nodes["totalSupply"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/total_supply/val")
		nodes["initialReserve"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/initial_reserve/val")
		nodes["meltValue"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/enj/val")
		nodes["result_enj"] = popup.get_node("tabs/Cryptoitems/top_panel/cost_panel/items/enj_per_item")
		nodes["result_count"] = popup.get_node("tabs/Cryptoitems/top_panel/cost_panel/items/item_count")
		nodes["result_cost"] = popup.get_node("tabs/Cryptoitems/top_panel/cost_panel/items/total_cost")
		nodes["enj_min_cost_title"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/enj/title")
		nodes["name"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/item/val")
		nodes["meltFeePercentage"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/melt/fee/val")
		nodes["token_id"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/transfer_settings/id/val")
		nodes["transferFeeSettings_value"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/transfer_settings/fee/val")
		nodes["whitelists_title"] = popup.get_node("tabs/Cryptoitems/p/mint_token/whitelists/title")
		nodes["whitelists_data"] = popup.get_node("tabs/Cryptoitems/p/mint_token/whitelists/panel/sc/data")
		nodes["icon"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/melt/icon/val")
		nodes["fungible"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/fungible/check")
		nodes["anim"] = popup.get_node("tabs/Cryptoitems/p/mint_token/anim")
		nodes["details"] = popup.get_node("tabs/Cryptoitems/p/details")
		nodes["details.item.name"] = popup.get_node("tabs/Cryptoitems/p/details/data/item_name/val")
		nodes["details.item.img"] = popup.get_node("tabs/Cryptoitems/p/details/data/item_img/val")
		nodes["details.item.type"] = popup.get_node("tabs/Cryptoitems/p/details/data/item_type/val")
		nodes["details.total.supply"] = popup.get_node("tabs/Cryptoitems/p/details/data/total_supply/val")
		nodes["details.total.reserve"] = popup.get_node("tabs/Cryptoitems/p/details/data/total_reserve/val")
		nodes["details.transferable"] = popup.get_node("tabs/Cryptoitems/p/details/data/transferable/val")
		nodes["details.supply.type"] = popup.get_node("tabs/Cryptoitems/p/details/data/supply_type/val")
		nodes["details.fee.ratio"] = popup.get_node("tabs/Cryptoitems/p/details/data/fee_ratio/val")
		nodes["details.enj.per.item"] = popup.get_node("tabs/Cryptoitems/p/details/data/enj_per_item/val")
		nodes["details.circulating"] = popup.get_node("tabs/Cryptoitems/p/details/data/circulating_supply/val")
		nodes["supply.model.btn"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/supply_type/opt")
		nodes["transferable.btn"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/transferable/opt")
		nodes["transfer.fee.settings.btn"] = popup.get_node("tabs/Cryptoitems/p/mint_token/grid/transfer_fee/opt")
		nodes["melt.popup"] = popup.get_node("tabs/Cryptoitems/p/melt_popup")
		nodes["mp.id"] = popup.get_node("tabs/Cryptoitems/p/melt_popup/data/item_id/val")
		nodes["mp.img"] = popup.get_node("tabs/Cryptoitems/p/melt_popup/data/item_img")
		nodes["mp.name"] = popup.get_node("tabs/Cryptoitems/p/melt_popup/data/item_name/val")
		nodes["mp.available"] = popup.get_node("tabs/Cryptoitems/p/melt_popup/data/available_count/val")
		nodes["mp.melt.fee"] = popup.get_node("tabs/Cryptoitems/p/melt_popup/data/creator_melt_fee/val")
		nodes["mp.numer.to.melt"] = popup.get_node("tabs/Cryptoitems/p/melt_popup/data/number_to_melt/val")
		nodes["mp.enj.return"] = popup.get_node("tabs/Cryptoitems/p/melt_popup/data/enj_return/val")
		nodes["mint.token.popup"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup")
		nodes["mi.id"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/data/item_id/val")
		nodes["mi.name"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/data/item_name/val")
		nodes["mi.img"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/data/item_img")
		nodes["mi.total.supply"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/data/total_supply/val")
		nodes["mi.total.reserve"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/data/total_reserve/val")
		nodes["mi.allowance"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/data/allowance/val")
		nodes["mi.balance"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/data/balance/val")
		nodes["mi.n.to.mint"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/data/number_to_mint/val")
		nodes["mi.transferto"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/data/transfer_to/r/val")
		nodes["mi.reserve.cost"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/data/reserve_cost/val")
		nodes["mi.total.cost"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/data/total_cost/val")
		nodes["melt.btn"] = popup.get_node("tabs/Cryptoitems/p/mint_token/btns/r1/melt")
		nodes["mint.btn"] = popup.get_node("tabs/Cryptoitems/p/mint_token/btns/r1/mint")
		nodes["mint.ok.btn"] = popup.get_node("tabs/Cryptoitems/p/mint_token_popup/ok")
		nodes["melt.ok.btn"] = popup.get_node("tabs/Cryptoitems/p/melt_popup/ok")
		nodes["create.save.token"] = popup.get_node("tabs/Cryptoitems/p/mint_token/btns/r2/create")

var token = ["nonFungible","name","balance","totalSupply","reserve","circulatingSupply","transferable","supplyModel"]

##### REQUIRED TYPES
var searchable = SEARCHABLE.DEFAULT
var SUPPLY_MODEL_TYPES = ["FIXED","SETTABLE","INFINITE","COLLAPSING"]
var SUPPLY_MODEL = SUPPLY_MODEL_TYPES[0]
var TRANSFERABLE_TYPES = ["PERMANENT","TEMPORARY","BOUND"]
var TRANSFERABLE = TRANSFERABLE_TYPES[0]
var TRANSFER_FEE_SETTINGS_TYPES = ["NONE","PER_CRYPTO_ITEM","PER_TRANSFER","FROM_BUNDLE"]
var TRANSFER_FEE_SETTING_TYPE = TRANSFER_FEE_SETTINGS_TYPES[0]
var CONSUMABLE_TYPE = ["false","true"]
var CONSUMABLE = CONSUMABLE_TYPE[0]

##### TOKENS PANEL SIGNALS [BTN,SIGNAL,FUNCTION_NAME]
var buttons = [["tabs/Cryptoitems/top_panel/mint_panel/open_t_btn", "pressed", "on_open_mint_token_Dialog"],
			   ["tabs/Cryptoitems/p/mint_token/btns/r2/cancel", "pressed", "on_cancel_mint_token_Dialog"],
			   ["tabs/Cryptoitems/p/mint_token/btns/r2/create", "pressed", "on_create_token"],
			   ["tabs/Cryptoitems/p/mint_token/btns/r1/delete", "pressed", "on_delete_token"],
			   ["tabs/Cryptoitems/p/mint_token/btns/r1/melt", "pressed", "on_melt_token"],
			   ["tabs/Cryptoitems/p/mint_token/btns/r1/mint", "pressed", "on_mint_token"],
			   ["tabs/Cryptoitems/p/mint_token/grid/melt/icon/btns/s", "pressed", "on_open_file_dialog"],
			   ["tabs/Cryptoitems/p/mint_token/grid/melt/icon/btns/u", "pressed", "on_upload_icon_to_tp"],
			   ["tabs/Cryptoitems/p/mint_token/grid/fungible/check", "pressed", "setNonFungible"],
			   ["tabs/Cryptoitems/p/mint_token/dialog_bg/file_dialog", "file_selected", "on_file_selected"],
			   ["tabs/Cryptoitems/p/mint_token/grid/initial_reserve/val", "text_changed", "update_enj_cost"],
			   ["tabs/Cryptoitems/p/mint_token/grid/enj/val", "text_changed", "update_enj_cost"],
			   ["tabs/Cryptoitems/p/mint_token_popup/data/number_to_mint/val", "text_changed", "update_mint_cost"],
			   ["tabs/Cryptoitems/top_panel/search_panel/search_btn", "pressed","search"],
			   ["tabs/Cryptoitems/p/details/close", "pressed","on_close_details"],
			   ["tabs/Cryptoitems/p/mint_token_popup/close", "pressed","on_close_mt_popup"],
			   ["tabs/Cryptoitems/p/melt_popup/close", "pressed","on_close_melt_popup"],
			   ["tabs/Cryptoitems/p/mint_token_popup/ok", "pressed","on_mint_ok"],
			   ["tabs/Cryptoitems/p/melt_popup/ok", "pressed","on_melt_ok"],
			   ["tabs/Cryptoitems/p/mint_token/grid/supply_type/opt", "item_selected", "on_token_item_selected"],
			   ["tabs/Cryptoitems/p/mint_token/grid/transferable/opt", "item_selected", "on_token_item_selected"],
			   ["tabs/Cryptoitems/p/mint_token/grid/transfer_fee/opt", "item_selected", "on_token_item_selected"],
			   ["tabs/Cryptoitems/top_panel/search_panel/opt", "item_selected","on_search_opt_selected"],
			   ["tabs/Cryptoitems/p/mint_token_popup/data/transfer_to/r/search","pressed","search_by_id"],
			   ["tabs","tab_selected","selected"]]

##### OPTIONS BUTTONS DEFAULT VALUES [BTN,VALUE]
var default_options = [["tabs/Cryptoitems/p/mint_token/grid/select/opt", "Unassigned"],
					   ["tabs/Cryptoitems/p/mint_token/grid/supply_type/opt", "Fixed"],
					   ["tabs/Cryptoitems/p/mint_token/grid/supply_type/opt", "Settable"],
					   ["tabs/Cryptoitems/p/mint_token/grid/supply_type/opt", "Infinite"],
					   ["tabs/Cryptoitems/p/mint_token/grid/supply_type/opt", "Collapsing"],
					   ["tabs/Cryptoitems/p/mint_token/grid/transferable/opt", "Permanent"],
					   ["tabs/Cryptoitems/p/mint_token/grid/transferable/opt", "Temporary"],
					   ["tabs/Cryptoitems/p/mint_token/grid/transferable/opt", "Bound"],
					   ["tabs/Cryptoitems/p/mint_token/grid/transfer_fee/opt", "None"],
					   ["tabs/Cryptoitems/p/mint_token/grid/transfer_fee/opt", "Per Crypto Item"],
					   ["tabs/Cryptoitems/p/mint_token/grid/transfer_fee/opt", "Per Transfer Event"],
					   ["tabs/Cryptoitems/p/mint_token/grid/transfer_fee/opt", "From Bundle"],
					   ["tabs/Cryptoitems/top_panel/search_panel/opt", "Global"],
					   ["tabs/Cryptoitems/top_panel/search_panel/opt", "Token ID"],
					   ["tabs/Cryptoitems/top_panel/search_panel/opt", "Token Name"],
					   ["tabs/Cryptoitems/top_panel/search_panel/opt", "Token Creator"]]

func _ready():
	pass

func _init(plugin, main):
	self.helper = main.helper
	self.references = NodesReferences.new(plugin.get_node("popup"))
	self.enjin_api = main.enjin_api
	self.enjinObj = main.enjin_api.obj
	
	node("file.dialog").get_cancel().connect("pressed",self,"on_close_file_dialog")
	node("file.dialog").get_close_button().connect("pressed",self,"on_close_file_dialog")
	self.references.popup.connect("popup_hide",self,"on_close_file_dialog")
	
	for btn in buttons:
		if !btn:
			break
		
		if btn[1] == "item_selected":
			##### ADD BTN PATH FOR AN OPTION BUTTON SIGNAL
			self.references.popup.get_node(btn[0]).connect(btn[1], self, btn[2], [btn[0]])
		else:
			self.references.popup.get_node(btn[0]).connect(btn[1], self, btn[2])
			
	for btn in default_options:
		self.references.popup.get_node(btn[0]).add_item(btn[1])

func node(name):
	if !references.nodes.has(name):
		return
	
	return references.nodes[name]

func update(e):
	match e:
		enjin_api.event.GET_TOKENS:
			var set = [0,enjinObj.tokens.size(),token,enjinObj.tokens]
			helper.populate_rows("token_template",
								 "tabs/Cryptoitems/p/sc/data",
								 set,
								 true,
								 self)
			helper.setup_navigation_bar("tabs/Cryptoitems/p/nav",
										enjinObj.tokens.size(),
										self)
		
		enjin_api.event.CREATE_TOKEN:
			pass
			#NOT YET IMPLEMENTED -> TOKEN_ID IS NULL WHEN CREATING A NEW TOKEN
			#enjin_api.request(EnjinTokens.new(enjinObj.newTokenId,SEARCHABLE.BYID).query,
			#		  self,
			#		  enjin_api.event.REFRESH_TOKEN_LIST)
		
		enjin_api.event.REFRESH_TOKEN_LIST:
			helper.update_navigation_bar("tabs/Cryptoitems/p/nav",
										 enjinObj.tokens.size(),
										 self)
		
		enjin_api.event.UPLOAD_IMAGE:
			var url = enjinObj.icon_url
			if url != "":
				node("icon").text = url.substr(0,6)+"..."+url.substr(url.length()-8,url.length()-1)

func search():
	enjinObj.tokens = []
	clear(false)
	helper.clear_navs(0)
	
	enjin_api.request(EnjinTokens.new(node("search.value").text,searchable).query,
					  self,
					  enjin_api.event.GET_TOKENS)

func clear(logout = true):
	self.enjinObj = enjin_api.obj

	for n in node("tokens.data").get_children():
		n.queue_free()
	
	on_cancel_mint_token_Dialog()
	
	if !logout:
		return
	
	for i in range(node("current.app").get_item_count()-1,0,-1):
		node("current.app").remove_item(i)
	
	node("open.mint.btn").disabled = false
	

func deferred_populate(set):
	set.append(token)
	set.append(enjinObj.tokens)
	
	helper.populate_rows("token_template",
						 "tabs/Cryptoitems/p/sc/data",
						 set,
						 false,
						 self)
 
func selected(tab):
	if tab == 1:
		if !enjinObj.role.has("manageTokens"):
			node("open.mint.btn").disabled = true
		
		if enjinObj.tokens.size() == 0:
			enjin_api.request(EnjinTokens.new().query,
							  self,
							  enjin_api.event.GET_TOKENS)

func on_open_mint_token_Dialog():
	if edit_token:
		node("create.save.token").disabled = true
	else:
		node("create.save.token").disabled = false
	
	helper.hide_and_show(["tabs/Cryptoitems/p/fixed",
						  "tabs/Cryptoitems/p/nav",
						  "tabs/Cryptoitems/p/sc",
						  "tabs/Cryptoitems/top_panel/mint_panel",
						  "tabs/Cryptoitems/top_panel/search_panel"],
						  ["tabs/Cryptoitems/p/mint_token",
						  "tabs/Cryptoitems/top_panel/balance_panel",
						  "tabs/Cryptoitems/top_panel/cost_panel"])

func on_cancel_mint_token_Dialog():
	node("anim").play("on_cancel")
	currentTokenId = ""
	edit_token = false
	helper.hide_and_show(["tabs/Cryptoitems/p/mint_token",
						  "tabs/Cryptoitems/top_panel/balance_panel",
						  "tabs/Cryptoitems/top_panel/cost_panel"],
						  ["tabs/Cryptoitems/p/fixed",
						  "tabs/Cryptoitems/p/nav",
						  "tabs/Cryptoitems/p/sc",
						  "tabs/Cryptoitems/top_panel/mint_panel",
						  "tabs/Cryptoitems/top_panel/search_panel"])

func update_enj_cost(val = 0):
	var total_supply = int(node("initialReserve").text)
	#var _decimals = float(node("decimals").value)
	var enjPerItem = float(node("meltValue").text)
	
	var minCostDiv = 100000000
	var costScaleDiv = 1000000000
	
	#var i_count = total_supply / pow(10,_decimals)
	var i_count = total_supply
	
	var minCost = 0.000
	
	if i_count != 0:
		minCost = sqrt(i_count * minCostDiv / costScaleDiv) / i_count
	
	if i_count > 0 and enjPerItem == 0:
		enjPerItem = minCost
	
	var meltValue = enjPerItem * pow(10,18)
	var totalCost = meltValue * i_count / pow(10,18)
	
	var scaleCalc = enjPerItem * minCostDiv / costScaleDiv
	
	node("enj_min_cost_title").text = "MELT VALUE (MIN COST: " +str(minCost) + ")"
	node("result_enj").text = str(enjPerItem)
	node("result_count").text = str(i_count)
	node("result_cost").text = str(totalCost)

func on_token_item_selected(idx, path):
	var node = references.popup.get_node(path)
	var type = node.get_parent().name
	
	if type == "supply_type":
		SUPPLY_MODEL = SUPPLY_MODEL_TYPES[idx]
	elif type == "transferable":
		TRANSFERABLE = TRANSFERABLE_TYPES[idx]
		if TRANSFERABLE == "TEMPORARY" or TRANSFERABLE == "BOUND":
			node("whitelists_title").text = TRANSFERABLE + " WHITELISTS"
			helper.hide_and_show([], ["tabs/Cryptoitems/p/mint_token/whitelists"])
		else:
			helper.hide_and_show(["tabs/Cryptoitems/p/mint_token/whitelists"], [])
	elif type == "transfer_fee":
		TRANSFER_FEE_SETTING_TYPE = TRANSFER_FEE_SETTINGS_TYPES[idx]
		if TRANSFER_FEE_SETTING_TYPE == "NONE":
			node("transferFeeSettings_value").value = 0
			node("transferFeeSettings_value").editable = false
		else:
			if currentTokenId != "":
				node("token_id").text = currentTokenId
			node("transferFeeSettings_value").editable = true

func setNonFungible():
	var val = 0
	if node("fungible").pressed:
		val = 1
		
	CONSUMABLE = CONSUMABLE_TYPE[val]

func on_create_token():
	var token = {}
	
	var totalSupply = node("totalSupply").text
	var initialReserve = node("initialReserve").text
	var meltValue = node("meltValue").text
	
	for i in [totalSupply,initialReserve,meltValue]:
		for v in i.to_ascii():
			if int(v) == 46: ## v = .
				continue
			
			if int(v) < 48 or int(v) > 57:
				helper.error(enjin_api.event.CREATE_TOKEN,"Invalid Numeric Value. Cannot contain letters or special characters.","finished_with_error")
				return
	
	var _decimals = 18 
	var decimal_point = meltValue.findn(".")
	print(str(decimal_point))
	var from = 0
	if decimal_point >= 1:
		_decimals -= (meltValue.length() - decimal_point - 1)
		meltValue.erase(decimal_point,1)
		
		if meltValue[0] == "0":
			for c in meltValue:
				if c == "0":
					from += 1
				else:
					break
	elif decimal_point == 0:
		helper.error(enjin_api.event.CREATE_TOKEN,"Invalid Melt Value. Floating point format example: 0.12","finished_with_error")
		return
	elif decimal_point == -1 and float(meltValue) > 0:
		if meltValue[0] == "0":
			helper.error(enjin_api.event.CREATE_TOKEN,"Invalid Melt Value","finished_with_error")
			return
	
	for i in range(_decimals):
		meltValue += "0"
	
	var _len = meltValue.length() 
	if node("meltValue").text == "" or float(meltValue) == 0:
		meltValue = ""
	else:
		meltValue = meltValue.substr(from, _len)
	
	var meltFeeRatio = (node("meltFeePercentage").value * 5000) / 50
	
	token["transferFeeSettings"] = """{type:"""+TRANSFER_FEE_SETTING_TYPE+""",token_id:\""""+str(0)+"""\",value:\""""+str(node("transferFeeSettings_value").value)+"""\"}"""
	#token["decimals"] = node("decimals").value
	token["name"] = node("name").text
	token["meltFeeRatio"] = str(meltFeeRatio)
	token["meltValue"] = meltValue
	token["totalSupply"] = totalSupply
	token["initialSupply"] = initialReserve
	#token["icon"] = enjinObj.icon_url
	token["transferable"] = "PERMANENT" ## HARD-CODED
	token["supplyModel"] = SUPPLY_MODEL
	token["nonFungible"] = CONSUMABLE
	
	var enjinToken = CreateEnjinTokenRequest.new(token, enjinObj.current_identity["id"])
	
	if enjinToken.error:
		helper.error(enjin_api.event.CREATE_TOKEN,enjinToken.error,"finished_with_error")
		return
		
	enjin_api.request(enjinToken.query,
					  self,
					  enjin_api.event.CREATE_TOKEN)
		
	on_cancel_mint_token_Dialog()

func on_mint_token(data=null):
	if !data:
		return
	
	set_up_mint_dialog(data)
	node("mint.token.popup").show()

func on_melt_token(data=null):
	if !data:
		return
	
	set_up_melt_dialog(data)
	node("melt.popup").show()

func on_delete_token():
	pass

func on_search_opt_selected(ID, p):
	if ID == 0:
		searchable = SEARCHABLE.DEFAULT
	elif ID == 1:
		searchable = SEARCHABLE.BYID
	elif ID == 2:
		searchable = SEARCHABLE.BYNAME
	elif ID == 3:
		searchable = SEARCHABLE.BYADDRESS

func on_open_file_dialog():
	helper.hide_and_show([],["tabs/Cryptoitems/p/mint_token/dialog_bg","tabs/Cryptoitems/p/mint_token/dialog_bg/file_dialog"])

func on_close_file_dialog():
	helper.hide_and_show(["tabs/Cryptoitems/p/mint_token/dialog_bg","tabs/Cryptoitems/p/mint_token/dialog_bg/file_dialog"],[])

func on_file_selected(path):
	node("icon").text = path
	on_close_file_dialog()

func on_upload_icon_to_tp():
	enjin_api.upload_image(node("icon").text, self, enjin_api.event.UPLOAD_IMAGE)

func manage_buttons(node, edible):
	if !enjinObj.role.has("manageTokens"):
		node.get_node("buttons/edit_btn").hide()
		node.get_node("buttons/sep").hide()
	else:
		if !edible:
			node.get_node("buttons/edit_btn").text = "Melt"
		
		node.get_node("buttons/edit_btn").show()
		node.get_node("buttons/sep").show()
	
	if !enjinObj.role.has("viewTokens"):
		node.get_node("buttons/view_btn").hide()
		node.get_node("buttons/sep").hide()

func on_edit_btn(btn,data):
	edit_token = true
	if node("melt.btn").is_connected("pressed",self,"on_melt_token"):
		node("melt.btn").disconnect("pressed",self,"on_melt_token")
	
	if node("mint.btn").is_connected("pressed",self,"on_mint_token"):
		node("mint.btn").disconnect("pressed",self,"on_mint_token")
	
	if node("melt.ok.btn").is_connected("pressed",self,"on_melt_ok"):
		node("melt.ok.btn").disconnect("pressed",self,"on_melt_ok")
	
	if node("mint.ok.btn").is_connected("pressed",self,"on_mint_ok"):
		node("mint.ok.btn").disconnect("pressed",self,"on_mint_ok")
	
	node("melt.btn").connect("pressed",self,"on_melt_token",[data])
	node("mint.btn").connect("pressed",self,"on_mint_token",[data])
	node("melt.ok.btn").connect("pressed",self,"on_melt_ok",[data])
	node("mint.ok.btn").connect("pressed",self,"on_mint_ok",[data])
	
	if btn.text == "Melt":
		set_up_melt_dialog(data)
		node("melt.popup").show()
		return
	
	node("anim").play("open_edit")
	node("totalSupply").text = data["totalSupply"]
	node("initialReserve").text = data["reserve"]
	node("meltValue").text = data["meltValue"]
	node("name").text = data["name"]
	if data["nonFungible"] == "Fungible":
		node("fungible").pressed = false
	else:
		node("fungible").pressed = true
	
	currentTokenId = data["token_id"]
	var transferable_idx = TRANSFERABLE_TYPES.find(data["transferable"].to_upper())
	if transferable_idx != -1:
		node("transferable.btn").select(transferable_idx)
	
	var supplyModel_idx = SUPPLY_MODEL_TYPES.find(data["supplyModel"])
	if supplyModel_idx != -1:
		node("supply.model.btn").select(supplyModel_idx)
	
	var transferFeeSettings_idx = TRANSFER_FEE_SETTINGS_TYPES.find(data["transferFeeSettings"]["type"])
	if transferFeeSettings_idx != -1:
		node("transfer.fee.settings.btn").select(transferFeeSettings_idx)
		node("transfer.fee.settings.btn").emit_signal("item_selected", transferFeeSettings_idx)
	
	on_open_mint_token_Dialog()

func set_mint_allowance(mint_allowance):
	node("mi.allowance").text = str(mint_allowance)

func update_mint_cost(val = 0):
	var n = float(node("mi.n.to.mint").text)
	
	var total = (n * reserve_enj_cost) - reserve_balance
	if total <= 0:
		total = 0
		
	node("mi.total.cost").text = str(total)

func set_up_mint_dialog(data):
	var getMintAllowance = GetMintAllowance.new(data["token_id"])
	
	enjin_api.request(getMintAllowance.query,
					  self,
					  enjin_api.event.GET_MINT_ALLOWANCE)
					
	node("mi.id").text = data["token_id"]
	node("mi.name").text = data["name"]
	#node("mi.img")
	node("mi.total.supply").text = data["totalSupply"]
	node("mi.total.reserve").text = data["reserve"]
	reserve_balance = float(data["meltValue"]) * float(data["reserve"])
	reserve_enj_cost = 1*float(data["meltValue"])
	node("mi.balance").text = str(reserve_balance)
	#node("mi.n.to.mint") 
	node("mi.transferto").text = str(enjinObj.current_identity["id"])
	node("mi.allowance").text = "-"
	node("mi.reserve.cost").text = str(reserve_enj_cost)
	node("mi.total.cost").text = "-"

func search_by_id():
	if node("mi.transferto").text == "":
		helper.error(enjin_api.event.GET_IDENTITY_BY_ID,"Missing Transfer To Id","finished_with_error")
		return
	
	var getIdentityById = GetIdentityById.new(node("mi.transferto").text)
	
	enjin_api.request(getIdentityById.query,
					  self,
					  enjin_api.event.GET_IDENTITY_BY_ID)

func set_transfer_to(eth_address):
	transferToAddress = eth_address
	node("mi.transferto").add_color_override("font_color", Color(0,1,0))
	node("mi.transferto").editable = false

func set_up_melt_dialog(data):
	node("mp.id").text = data["token_id"] 
	#node("mp.img") 
	node("mp.name").text = data["name"]
	node("mp.available").text = "-"
	#node("mp.numer.to.melt") 
	var melt_fee = (int(data["meltFeeRatio"]) * 50) / 5000
	node("mp.melt.fee").text = str(melt_fee) + " %"
	node("mp.enj.return").text = "-"

func on_mint_ok(data=null):
	if !data:
		return
	
	if transferToAddress == "":
		helper.error(enjin_api.event.MINT_TOKEN,"Missing Transfer To Id - Set the id and click Search to check for availability.","finished_with_error")
		return
	
	var token = {}
	token["token_id"] = data["token_id"]
	token["token_index"] = data["index"] if data["index"] != "" else "0"
	token["recipient_address"] = transferToAddress
	token["recipient_identity_id"] = str(enjinObj.current_user["id"])
	token["value"] = node("mi.n.to.mint").text
	
	var mintToken = MintEnjinTokenRequest.new(token, enjinObj.current_identity["id"])
	print(mintToken.query)
	
	if mintToken.error:
		helper.error(enjin_api.event.MINT_TOKEN,mintToken.error,"finished_with_error")
		return
		
	enjin_api.request(mintToken.query,
					  self,
					  enjin_api.event.MINT_TOKEN)
	
	on_close_mt_popup()

func on_melt_ok(data=null):
	if !data:
		return
	
	var token = {}
	token["token_id"] = data["token_id"]
	token["token_index"] = data["index"] if data["index"] != "" else "0"
	token["value"] = node("mp.numer.to.melt").text
	
	var meltToken = MeltEnjinTokenRequest.new(token, enjinObj.current_identity["id"])
	print(meltToken.query)
	
	if meltToken.error:
		helper.error(enjin_api.event.MELT_TOKEN,meltToken.error,"finished_with_error")
		return
		
	enjin_api.request(meltToken.query,
					  self,
					  enjin_api.event.MELT_TOKEN)
	
	on_close_melt_popup()

func on_view_btn(btn,data):
	show_details(data)

func on_close_details():
	node("details").hide()

func on_close_melt_popup():
	node("melt.popup").hide()
	node("mp.numer.to.melt").text = ""

func on_close_mt_popup():
	node("mint.token.popup").hide()
	transferToAddress = ""
	node("mi.transferto").add_color_override("font_color", Color(1,1,1))
	node("mi.transferto").editable = true
	node("mi.transferto").text = ""
	node("mi.n.to.mint").text = ""

func show_details(data):
	var bb_code = "[b][color=grey]{text}[/color][/b]"
	
	node("details.item.name").bbcode_text = bb_code.replace("{text}",data["name"])
	node("details.item.type").bbcode_text = bb_code.replace("{text}",data["nonFungible"])
	node("details.total.supply").bbcode_text = bb_code.replace("{text}",data["totalSupply"])
	node("details.total.reserve").bbcode_text = bb_code.replace("{text}",data["reserve"])
	node("details.transferable").bbcode_text = bb_code.replace("{text}",data["transferable"])
	node("details.supply.type").bbcode_text = bb_code.replace("{text}",data["supplyModel"])
	node("details.fee.ratio").bbcode_text = bb_code.replace("{text}",data["meltFeeRatio"])
	node("details.enj.per.item").bbcode_text = bb_code.replace("{text}",data["meltValue"])
	node("details.circulating").bbcode_text = bb_code.replace("{text}",data["circulatingSupply"])
	node("details").show()

