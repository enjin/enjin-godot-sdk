extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
class APIClient:
	var url
	var request_queue = []
	const ATTEMPTS = 5

	var thread
	var sem
	var mutex
	var quit_thread = false

	var req_count = 0
	
	var headers = [
	    "Content-Type: application/json"
	]
	
	func relayRequest(method, endpoint, data, callback):
		send_request([method, endpoint, data], callback)

	func _client_release(client):
		pass # maybe put back in client pool

	func thread_func(udata):
	
		while !quit_thread:
		
			sem.wait()

			while request_queue.size() > 0:
				
				for i in range(request_queue.size()):

					if typeof(request_queue[i]) != TYPE_ARRAY:
						continue
					var req = request_queue[i]
					var client = req[0]

					if client == null:
						client = HTTPClient.new()
						var error = client.connect_to_host(url, 443, true, true)
						
						if error != OK:
							client = null
							quit_thread = true
							request_queue.empty()
							print("Failed to connect to host")
							return
							
						request_queue[i][0] = client

					var status = client.get_status()
					printt("req status ", i, status)

					if status == HTTPClient.STATUS_BODY:
						client.poll()
						if req.size() < 4:
							var arr = PoolByteArray()
							req.push_back(arr)
						var chunk = client.read_response_body_chunk()
						if chunk.size() > 0:
							req[3] = req[3] + chunk
						
					elif status == HTTPClient.STATUS_CONNECTED:
						if req.size() >= 4: # has the body
							handle_response(req)
							_client_release(req[0])
							request_queue[i] = false
						else:

							var vals = req[1]
							
							if typeof(vals[2]) == TYPE_RAW_ARRAY:
								var err = client.request_raw(vals[0], vals[1], headers, vals[2])
							else:
								var err = client.request(vals[0], vals[1], headers, vals[2])

							client.poll()

					elif status == HTTPClient.STATUS_CANT_RESOLVE || status == HTTPClient.STATUS_CANT_CONNECT || status == HTTPClient.STATUS_CONNECTION_ERROR || status == HTTPClient.STATUS_SSL_HANDSHAKE_ERROR:
						handle_response(req)
						_client_release(req[0])
						request_queue[i] = false

					else:
						client.poll()
				

				var i = request_queue.size()
				while i:
					i -= 1
					if typeof(request_queue[i]) == TYPE_BOOL:
						mutex.lock()
						request_queue.remove(i)
						mutex.unlock()
		
				OS.delay_msec(100)
			

	func send_request(vals, callback):
	
		var req = [null, vals, callback]
		mutex.lock()
		request_queue.push_back(req)
		mutex.unlock()

		sem.post()
		
		req_count += 1
		return req_count

	func handle_response(req):
		var body
		
		if req.size() < 4: # no body
			body = "failed"
		else:
			body = req[3].get_string_from_ascii()
		
		response_dispatch(req[2], body)

	func response_dispatch(callback, message):
	
		var udata = null
		if callback.size() > 2:
			udata = callback[2]

		printt("dispatching call to ", callback)			
		callback[0].call_deferred(callback[1], message, udata)
	
	func _init(api_url):
		sem = Semaphore.new()
		mutex = Mutex.new()
		url = api_url
		self.add_user_signal("received_response")

		thread = Thread.new()
		thread.start(self,"thread_func", null)

class EnjinObjects:
	var identities = []
	var tokens = []
	var team = []
	var transactions = []
	var current_user = null
	var platform_apps = []
	var current_identity = null
	var current_app = ""
	var icon_url = ""
	var role = []
	var roles = {}
	var balance = {}
	var newTokenId = ""
	
	func change_role(app_id):
		for key in current_user["apps"].keys():
			var app = current_user["apps"][key]
			if(app["id"] == app_id):
				current_user["role_name"] = app["role"]
		
		role = roles[current_user["role_name"]]
	
	func check_identity():
		for identity in current_user["identities"]:
			if identity["app"]["name"] == current_app:
				current_identity = identity
				return true
		
		return false
	
	func setUpUser(response):
		current_user = {}
		current_user["user"] = response["EnjinOauth"]["name"]
		current_user["id"] = response["EnjinOauth"]["id"]
		current_user["email"] = response["EnjinOauth"]["email"]
		
		if response["EnjinOauth"].has("roles"):
			if response["EnjinOauth"]["roles"].size() >= 1:
				if response["EnjinOauth"]["roles"][0]["permissions"].size() >= 1:
					current_user["permissions"] = response["EnjinOauth"]["roles"][0]["permissions"]
					for p in current_user["permissions"]:
						role.append(p["name"])
		if typeof(response["EnjinOauth"]["access_tokens"]) == TYPE_ARRAY and response["EnjinOauth"]["access_tokens"].size() >= 1:
			current_user["token"] = response["EnjinOauth"]["access_tokens"][0]["access_token"]
		
		current_user["identities"] = response["EnjinOauth"]["identities"]
		
		current_user["apps"] = {}
		for i in current_user["identities"]:
			if i["app"] != null:
				current_user["apps"][i["app"]["name"]] = {"id":i["app"]["id"],"role":i["app"]["roles"][0]["name"]}
		
		if(current_user["apps"].size() > 0):
			var first_app_n = current_user["apps"].keys()[0]
			current_user["role_name"] = current_user["apps"][first_app_n]["role"]
			
		platform_apps = response["EnjinOauth"]["apps"] if response["EnjinOauth"]["apps"] != null else []

	func saveApp(response):
		if response.has("CreateEnjinApp"):
			var data = response["CreateEnjinApp"]
			current_user["apps"][data["name"]] = {"id":data["id"],"role":data["roles"][0]["name"]}
			for identity in data["identities"]:
				current_user["identities"].append(identity)
			
			data.erase("identities")
			platform_apps.append(data)
	
	func updateApp(response):
		if response.has("UpdateEnjinApp"):
			var data = response["UpdateEnjinApp"]
			var idx = -1
			for i in range(platform_apps.size()):
				if platform_apps[i]["name"] == current_app:
					idx = i
					break
			
			if idx != -1:
				platform_apps.remove(idx)
			
			platform_apps.append(data)
			current_user["apps"][data["name"]]["id"] = data["id"]
			current_app = data["name"]
	
	func setUpRoles(response):
		var data = null
		if response.has("EnjinRoles"):
			data = response["EnjinRoles"]
		elif response.has("CreateEnjinRole"):
			data = response["CreateEnjinRole"]
			
		if !data:
			return
		
		##### APPEND NEW ROLE !!
		if typeof(data) == TYPE_DICTIONARY and data.has("permissions"):
			var p_arr = []
			for p in data["permissions"]:
				p_arr.append(p["name"])
			
			roles[data["name"]] = p_arr
			return
		
		##### RETRIEVE EXISTING ROLES
		for r in data:
			var p_arr = []
			for p in r["permissions"]:
				p_arr.append(p["name"])
			
			roles[r["name"]] = p_arr
	
	func updateBearer():
		return str(current_identity["app"]["id"])+"@"+current_user["token"]
	
	func saveBalance(response):
		if response.has("EnjinIdentities"):
			var data = response["EnjinIdentities"]
			if data.size() < 0:
				return
				
			balance["token_count"] = str(data[0]["all_tokens_balance"]["token_count"])
			balance["enj_value"] = str(data[0]["all_tokens_balance"]["enj_value"])
			balance["enj_balance"] = str(data[0]["enj_balance"])
			balance["eth_balance"] = str(data[0]["eth_balance"])

	
	func setUpTeam(response):
		var start = 0
		var end 
		if response.has("EnjinUsers"):
			team = response["EnjinUsers"]
			end = team.size()
		elif response.has("CreateEnjinUser"):
			team.append(response["CreateEnjinUser"])
			start = team.size() - 1
			end = team.size()
		elif response.has("UpdateEnjinUser"):
			var uuser = response["UpdateEnjinUser"]
			for i in range(team.size()):
				if team[i]["id"] == uuser["id"]:
					team[i] = uuser
					start = i
					end = i + 1
					break
			
		for i in range(start,end):
			var user = team[i]
			if user.has("roles"):
				if user["roles"].size() >= 1:
					user["role_name"] = user["roles"][0]["name"]
				user.erase("roles")
			if user.has("identities"):
				if user["identities"].size() >= 1:
					user["identity_id"] = user["identities"][0]["id"]
				user.erase("identities")
	
	func removeUser(response):
		if response.has("DeleteEnjinUser"):
			var del_user = response["DeleteEnjinUser"]
			for i in range(team.size()):
				if team[i]["id"] == del_user["id"]:
					team.remove(i)
					return
		
		print(team)
	
	func setUpIdentities(response):
		if response.has("EnjinIdentities"):
			identities = response["EnjinIdentities"]
			for identity in identities:
				if identity["linking_code"] == null:
					identity["linking_code"] = "Linked"
	
	func removeIdentity(response):
		if response.has("DeleteEnjinIdentity"):
			var del_identity = response["DeleteEnjinIdentity"]
			for i in range(identities.size()):
				if identities[i]["id"] == del_identity["id"]:
					identities.remove(i)
					return
	
	func setUpIdentity(response):
		if response.has("EnjinOauth"):
			if typeof(response["EnjinOauth"]["identities"]) == TYPE_ARRAY:
				if response["EnjinOauth"]["identities"].size() >= 1:
					current_identity = response["EnjinOauth"]["identities"][0]
		elif response.has("CreateEnjinIdentity") or response.has("UpdateEnjinIdentity") or response.has("DeleteEnjinIdentity") or response.has("EnjinIdentities"):
			var key = "" 
			if response.has("CreateEnjinIdentity"):
				key = "CreateEnjinIdentity"
			elif response.has("UpdateEnjinIdentity"):
				key = "UpdateEnjinIdentity"
			elif response.has("DeleteEnjinIdentity"):
				key = "DeleteEnjinIdentity"
			elif response.has("EnjinIdentities"):
				key = "EnjinIdentities"
			else:
				return true
			
			var identity = null
			if typeof(response[key]) == TYPE_ARRAY:
				if response[key].size() != 1:
					return true
					
				identity = response[key][0]
			else:
				identity = response[key]
			
			current_identity = identity 
			for i in range(current_user["identities"].size()):
				if current_user["identities"][i]["id"] == identity["id"]:
					current_user["identities"][i] = identity
					return false
					
			current_user["identities"].append(identity)
		
		return false
	
	func setUpTokenIconURL(response):
		if response.has("hash"):
			icon_url = response["hash"]
	
	func saveNewTokenId(response):
		if response.has("CreateEnjinRequest"):
			print(response["CreateEnjinRequest"])
			newTokenId = str(response["CreateEnjinRequest"]["token_id"])
	
	func setUpTokens(response, newToken = false):
		if response.has("EnjinTokens"):
			tokens = response["EnjinTokens"]
		
		var _range = 0
		if newToken:
			_range = tokens.size() - 1
			
		for i in range(_range,tokens.size()):
			if typeof(tokens[i]) == TYPE_DICTIONARY:
				for key in tokens[i].keys():
					if tokens[i][key] == null:
						tokens[i][key] = ""
					if key == "creator":
						if tokens[i][key].matchn(current_identity["ethereum_address"]):
							tokens[i]["edible"] = true
						else:
							tokens[i]["edible"] = false
					elif key == "nonFungible":
						if tokens[i][key]:
							tokens[i][key] = "nonFungible"
						else:
							tokens[i][key] = "Fungible"
					elif key == "transferable":
						if int(tokens[i][key]) == 0:
							tokens[i][key] = "Permanent"
						if int(tokens[i][key]) == 1:
							tokens[i][key] = "Temporary"
						if int(tokens[i][key]) == 2:
							tokens[i][key] = "Bound"
					elif key == "meltValue" and typeof(tokens[i][key]) == TYPE_STRING:
						if tokens[i][key].length() > 18:
							var length = tokens[i][key].length() 
							var _decimals = "."
							for j in range(length - 18, length):
								if tokens[i][key][j] != "0":
									_decimals += tokens[i][key][j]
							
							tokens[i][key] = tokens[i][key].substr(0, length - 18)
							tokens[i][key] += _decimals if _decimals != "." else ""
						else:
							var aux="0."
							var _str =  tokens[i][key]
							
							if tokens[i][key].length() < 18:
								for i in range(18 - _str.length()):
									aux+="0"
							
							for c in _str:
								if c == "0":
									break
								
								aux+=c
								
							tokens[i][key] = aux

var api
var news_client
var url = "master.cloud.enjin.dev" ## DEFAULT URL
var obj
var helper

var GRAPHQL = "/graphql"

enum event{
	LOGIN,
	LOGOUT,
	CREATE_USER,
	UPDATE_USER,
	DELETE_USER,
	GET_TEAM,
	CREATE_IDENTITY,
	UPDATE_IDENTITY,
	UNLINK_IDENTITY,
	DELETE_IDENTITY,
	GET_IDENTITIES,
	FUND_WALLET,
	CREATE_TOKEN,
	MINT_TOKEN,
	MELT_TOKEN,
	GET_TOKENS,
	REFRESH_TOKEN_LIST,
	SEND_REQUEST,
	UPLOAD_IMAGE,
	CREATE_ROLE,
	GET_ROLES,
	GET_BALANCE,
	CREATE_APP,
	EDIT_APP,
	DECODE_DATA,
	GET_NEWS,
	GET_MINT_ALLOWANCE,
	GET_IDENTITY_BY_ID
}

func receive_news(response, pdata):
	if response == "failed":
		return
	
	var json = parse_json(response)
	if json == null:
		return
	
	if !json["result"].has("news"):
		return
	
	pdata[0].call_deferred("set_news", json["result"]["news"])

func update_enjin_obj(response, pdata):
	if response == "failed":
		var error = "Failed Request"
		helper.error(pdata[1],error,"finished_with_error",pdata[0])
		return
	
	var json = parse_json(response)
	if json == null:
		var error = "Response body is not a json - Saving html file"
		helper.error(pdata[1],error,"finished_with_error",pdata[0])
		var dir = Directory.new()
		if !dir.dir_exists("res://errors"):
			dir.make_dir("res://errors")
		
		var file = File.new()
		var date = OS.get_datetime()
		file.open("res://errors/error_" + 
				  str(date["year"]) + str(date["day"]) + str(date["month"]) +
				  str(date["hour"]) + str(date["minute"]) + str(date["second"]) +
				  ".html", 
				  file.WRITE)
		file.store_string(response)
		file.close()
		return
	
	if json.has("errors"):
		var error = "Error Code : " + str(json["errors"][0]["code"]) + " -> " + json["errors"][0]["message"]
		helper.error(pdata[1],error,"finished_with_error",pdata[0])
		return
	elif json.has("error"):
		helper.error(pdata[1],json["error"],"finished_with_error",pdata[0])
		return
	
	match pdata[1]:
		event.LOGIN:
			obj.setUpUser(json["data"])
			obj.setUpIdentity(json["data"])
			#print("Current user --> ", obj.current_user)
			if obj.current_user.has("token"):
				api.headers.append("Authorization:Bearer " + obj.current_user["token"])
	
		event.UPLOAD_IMAGE:
			obj.setUpTokenIconURL(json)
	
		event.CREATE_APP:
			obj.saveApp(json["data"])
		
		event.EDIT_APP:
			obj.updateApp(json["data"])
	
		event.CREATE_IDENTITY, event.UPDATE_IDENTITY, event.UNLINK_IDENTITY:
			var err = obj.setUpIdentity(json["data"])
			if err:
				helper.error(pdata[1],"Invalid Response array !!","finished_with_error",pdata[0])
				return
	
		event.DELETE_IDENTITY:
			obj.removeIdentity(json["data"])
	
		event.DELETE_USER:
			obj.removeUser(json["data"])
	
		event.FUND_WALLET:
			print(json)
	
		event.GET_BALANCE:
			obj.saveBalance(json["data"])
	
		event.GET_TOKENS:
			obj.setUpTokens(json["data"])
	
		event.CREATE_TOKEN:
			obj.saveNewTokenId(json["data"])
	
		event.REFRESH_TOKEN_LIST:
			obj.setUpTokens(json["data"],true)
	
		event.DECODE_DATA:
			print(json["data"])
	
		event.GET_IDENTITIES:
			obj.setUpIdentities(json["data"])
	
		event.GET_TEAM, event.CREATE_USER, event.UPDATE_USER:
			obj.setUpTeam(json["data"])
	
		event.CREATE_ROLE:
			obj.setUpRoles(json["data"])
	
		event.GET_ROLES:
			obj.setUpRoles(json["data"])
	
		event.GET_MINT_ALLOWANCE:
			var mint_allowance = 0
			if json["data"].has("EnjinTokens"):
				if json["data"]["EnjinTokens"].size() == 1:
					mint_allowance = json["data"]["EnjinTokens"][0]["availableToMint"]
			pdata[0].call_deferred("set_mint_allowance", mint_allowance)
	
		event.GET_IDENTITY_BY_ID:
			var eth_address = 0
			if json["data"].has("EnjinIdentities"):
				if json["data"]["EnjinIdentities"].size() == 1:
					eth_address = json["data"]["EnjinIdentities"][0]["ethereum_address"]
			pdata[0].call_deferred("set_transfer_to", eth_address)
	
	helper.loading(pdata[1],"finished")
	pdata[0].call_deferred("update", pdata[1])

func update_bearer():
	var idx = -1
	for i in range(api.headers.size()):
		if api.headers[i].find("Authorization:") != -1:
			idx = i
			break
			
	if idx == -1:
		printt("Failed to update Header !! Missing Authorization Header")
		return
	
	api.headers[idx] = "Authorization:Bearer " + obj.updateBearer()

func request(query, panel, event):
	helper.loading(event,"loading")
	api.relayRequest(HTTPClient.METHOD_POST, GRAPHQL, query, [self, "update_enjin_obj", [panel,event]])

func upload_image(img, panel, event):
	helper.loading(event,"loading")
	var arr = img.split("/")
	arr = arr[arr.size() - 1].split(".")
	
	var file = File.new()
	file.open(img, file.READ)
	var buffer = file.get_buffer(file.get_len())
	file.close()
	var r = to_json({"image":Marshalls.raw_to_base64(buffer),
					 "type":arr[arr.size() - 1]})
	
	api.relayRequest(HTTPClient.METHOD_POST,
					 "/api/v1/images",
					 r,
					 [self, "update_enjin_obj", [panel,event]])

func decode_data(data, panel, event):
	var body = {"method":"tokenData",
	            "output":true,
	            "data":data}
	
	print(to_json(body))
	api.relayRequest(HTTPClient.METHOD_POST,
					 "/api/v1/ethereum/custom-tokens/decode-data",
					 to_json(body),
					 [self, "update_enjin_obj", [panel,event]])

func get_news(panel,event):
	news_client = APIClient.new("api.enjinx.io")
	news_client.headers.append("Authorization: 51b2fc32-4095-48d4-8203-f889ccd81d5f")
	news_client.relayRequest(HTTPClient.METHOD_GET,
							 "/v1/misc/getUnityInfo",
							 "",
							 [self, "receive_news", [panel,event]])

func log_out():
	obj = EnjinObjects.new()
	if api.headers.size() == 2:
		api.headers.pop_back()

func create_client(_url):
	var aux = _url.split("/")
	
	if aux[0] == "https:" or aux[0] == "http:":
		url = aux[2]
	else:
		url = aux[0]
	
	api = APIClient.new(url) #master.tp-enj.in

func _init(_helper):
	obj = EnjinObjects.new()
	helper = _helper
