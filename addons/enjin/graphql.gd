extends Control

enum SEARCHABLE{
    DEFAULT,
    BYID,
    BYNAME,
    BYEMAIL,
    BYLINKINGCODE,
    BYADDRESS
}

class EnjinOauth:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(email,password):
        return """query{
                      EnjinOauth(email:\""""+email+"""\", password:\""""+password+"""\"){
                          id
                          name
                          email
                          access_tokens
                          roles{
                              id
                              name
                              app_id
                              permissions{
                                  id
                                  name
                              }
                          }
                          identities{
                              id
                              linking_code
                              ethereum_address
                              app{
                                  id
                                  name
                                  roles{
                                     name
                                  }
                              }
                          }
                          apps{
                              id
                              name
                              description
                              image
                          }
                      }
                  }"""

    func _init(email, password):
        var body = {}
        body["query"] = set_query(email, password)
        query = to_json(body)

class CreateEnjinUser:
    var query setget ,get_query
    var error setget ,get_error

    func get_query():
        return query

    func get_error():
        return error

    func set_query(app_id, email, name, password, role):
        var r = ""
        if role != "":
            r = "role:\""+role+"\""

        return """mutation{
                      CreateEnjinUser(app_id:"""+app_id+""",email:\""""+email+"""\", name:\""""+name+"""\",password:\""""+password+"""\""""+r+"""){
                          id
                          name
                          email
                          roles{
                              id
                              name
                          }
                          identities{
                              id
                          }
                      }
                  }"""

    func _init(args):
        var missing_args = ""
        var separetor = " "
        for arg in args.keys():
            if str(args[arg]) == "":
                missing_args += separetor + arg
                separetor = " | "

        if missing_args != "":
            error = "The following arguments are missing:"+missing_args+". Please add them"

        var body = {}
        body["query"] = set_query(str(args["app_id"]), args["email"], args["username"], args["password"], args["role"])
        query = to_json(body)

class UpdateEnjinUser:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(id,name,email,identity_id,role):
        var args = ""

        if name != "":
            args+= ",name:\""+name+"\""

        if email != "":
            args+= ",email:\""+email+"\""

        if identity_id != "":
            args+= ",identity_id:"+identity_id

        if role != "":
            args+= ",roles:[\""+role+"\"]"

        return """mutation{
                      UpdateEnjinUser(id:"""+id+args+"""){
                          id
                          name
                          email
                          roles{
                              id
                              name
                          }
                          identities{
                              id
                          }
                      }
                  }"""

    func _init(id,name,email,identity_id,role):
        var body = {}
        body["query"] = set_query(str(id),name,email,str(identity_id),role)
        query = to_json(body)

class DeleteEnjinUser:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(id):
        return """mutation{
                      DeleteEnjinUser(id:"""+id+"""){
                          id
                      }
                  }"""

    func _init(id):
        var body = {}
        body["query"] = set_query(str(id))
        query = to_json(body)

class EnjinUsers:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(param,searchable):
        var fields = ""

        if searchable == SEARCHABLE.BYID:
            fields = "(id:"+str(param)+")"
        elif searchable == SEARCHABLE.BYNAME:
            fields = "(name:\""+str(param)+"\")"
        elif searchable == SEARCHABLE.BYEMAIL:
            fields = "(email:\""+str(param)+"\")"

        return """query{
                      EnjinUsers"""+fields+"""{
                          id
                          name
                          email
                          roles{
                              id
                              name
                          }
                          identities{
                              id
                          }
                      }
                  }"""

    func _init(param = null,searchable = SEARCHABLE.DEFAULT):
        var body = {}
        body["query"] = set_query(param,searchable)
        query = to_json(body)

class UpdateEnjinIdentity:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(id, user_id, linking_code, eth_address):
        var args = ""
        if user_id != "":
            args += ",user_id:"+user_id

        if eth_address != "":
            args+= ",ethereum_address:"+"\""+eth_address+"\""

        if linking_code != "":
            args+= ",linking_code:"+"\""+linking_code+"\""

        return """mutation{
                      UpdateEnjinIdentity(id:"""+id+args+"""){
                          id
                          linking_code
                          ethereum_address
                          app{
                              id
                              name
                          }
                      }
                  }"""

    func _init(id, user_id, linking_code, eth_address):
        var body = {}
        body["query"] = set_query(str(id), str(user_id), linking_code, eth_address)
        query = to_json(body)

class UnlinkEnjinIdentity:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(id):
        return """mutation{
                      DeleteEnjinIdentity(id:"""+id+""",unlink:true){
                          id
                          linking_code
                          ethereum_address
                          app{
                              id
                              name
                          }
                      }
                  }"""

    func _init(id):
        var body = {}
        body["query"] = set_query(str(id))
        query = to_json(body)

class DeleteEnjinIdentity:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(id):
        return """mutation{
                      DeleteEnjinIdentity(id:"""+id+""",unlink:false){
                          id
                      }
                  }"""

    func _init(id):
        var body = {}
        body["query"] = set_query(str(id))
        query = to_json(body)

class CreateEnjinIdentity:
    var query setget ,get_query
    var error setget ,get_error

    func get_query():
        return query

    func get_error():
        return error

    func set_query(user_id, ethereum_address):
        if ethereum_address != "":
            var aux = ",ethereum_address:\"" + ethereum_address + "\""
            ethereum_address = aux

        return """mutation{
                      CreateEnjinIdentity(user_id:"""+user_id+ethereum_address+"""){
                          id
                          linking_code
                          ethereum_address
                          app{
                              id
                              name
                          }
                      }
                  }"""

    func _init(user_id, ethereum_address = ""):
        if str(user_id) == "":
            error = "User ID cannot be empty !!!"

        var body = {}
        body["query"] = set_query(str(user_id), ethereum_address)
        query = to_json(body)

class EnjinIdentities:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(param,searchable):
        var fields = ""

        if searchable == SEARCHABLE.BYID:
            fields = "(id:"+str(param)+")"
        elif searchable == SEARCHABLE.BYADDRESS:
            fields = "(ethereum_address:\""+str(param)+"\")"
        elif searchable == SEARCHABLE.BYLINKINGCODE:
            fields = "(linking_code:\""+str(param)+"\")"

        return """query{
                      EnjinIdentities"""+fields+"""{
                          id
                          linking_code
                          ethereum_address
                          user{
                              id
                              name
                          }
                          app{
                              id
                              name
                          }
                      }
                  }"""

    func _init(param = null,searchable = SEARCHABLE.DEFAULT):
        var body = {}
        body["query"] = set_query(param,searchable)
        query = to_json(body)

class CreateEnjinTokenRequest:
    var query setget ,get_query
    var error setget ,get_error

    func get_query():
        return query

    func get_error():
        return error

    func set_query(token,identity_id):
        return """mutation {
                      CreateEnjinRequest(identity_id:"""+str(identity_id)+""",type:CREATE,
                                         create_token_data:{name:\""""+token["name"]+"""\",
                                                            totalSupply:"""+token["totalSupply"]+""",
                                                            initialReserve:"""+token["initialSupply"]+""",
                                                            supplyModel:"""+token["supplyModel"]+""",
                                                            meltValue:\""""+token["meltValue"]+"""\",
                                                            meltFeeRatio:"""+token["meltFeeRatio"]+""",
                                                            transferable:"""+token["transferable"]+""",
                                                            transferFeeSettings:"""+token["transferFeeSettings"]+""",
                                                            nonFungible:"""+token["nonFungible"]+""",
                                                            icon:""}){
                              id
                              transaction_id
                              token_id
                              type
                              encoded_data
                              state
                              accepted
                              title
                          }
                      }"""

    func _init(token,identity_id):
        if typeof(token) == TYPE_DICTIONARY:
            var missing_vals = []
            #if token["icon"].find("res://") != -1:
            #	error = "Upload the corresponding Icon to the Trusted Platform"
            #else:
            for key in token.keys():
                if str(token[key]) == "" or token[key] == null:
                    missing_vals.append(key)

            if missing_vals.size() >= 1:
                var map = {"transferFeeSettings":"TRANSFER FEE SETTINGS",
                           "name":"ITEM NAME",
                           "meltFeeRatio":"MELT FEE %",
                           "meltValue":"ENJ PER ITEM",
                           "totalSupply":"TOTAL SUPPLY",
                           "initialSupply":"INITIAL RESERVE",
                           #"icon":"ICON",
                           "transferable":"TRANSFERABLE",
                           "supplyModel":"SUPPLY MODEL",
                           "nonFungible":"ITEM"}

                error = "Please complete the following :"
                var sep = " "
                for e in missing_vals:
                    error += sep + map[e]
                    sep = " / "
        else:
            error = "Invalid Argument type"

        var body = {}
        body["query"] = set_query(token,identity_id)
        query = to_json(body)

class SendEnjinTokenRequest:
    var query setget ,get_query
    var error setget ,get_error

    func get_query():
        return query

    func get_error():
        return error

    func set_query(token,identity_id):
        return """mutation {
                      CreateEnjinRequest(identity_id:"""+str(identity_id)+""",type:SEND,
                                         send_token_data:{token_id:\""""+token["token_id"]+"""\",
                                                          token_index:"""+token["token_index"]+""",
                                                          recipient_address:"""+token["recipient_address"]+""",
                                                          recipient_identity_id:"""+token["recipient_identity_id"]+""",
                                                          value:\""""+token["value"]+"""\"}){
                              token{
                                  token_id
                                  name
                              }
                          }
                      }"""

    func _init(token,identity_id):
        if typeof(token) == TYPE_DICTIONARY:
            var missing_vals = []
            for key in token.keys():
                if str(token[key]) == "" or token[key] == null:
                    missing_vals.append(key)

            if missing_vals.size() >= 1:
                var map = {}

                error = "Please complete the following :"
                var sep = " "
                for e in missing_vals:
                    error += sep + map[e]
                    sep = " / "
        else:
            error = "Invalid Argument type"

        var body = {}
        body["query"] = set_query(token,identity_id)
        query = to_json(body)

class MintEnjinTokenRequest:
    var query setget ,get_query
    var error setget ,get_error

    func get_query():
        return query

    func get_error():
        return error

    func set_query(token,identity_id):
        return """mutation {
                      CreateEnjinRequest(identity_id:"""+str(identity_id)+""",type:MINT,
                                         mint_token_data:{token_id:\""""+token["token_id"]+"""\",
                                                          token_index:\""""+token["token_index"]+"""\",
                                                          recipient_address:\""""+token["recipient_address"]+"""\",
                                                          recipient_identity_id:"""+token["recipient_identity_id"]+""",
                                                          value:"""+token["value"]+"""}){
                              token{
                                  token_id
                                  name
                              }
                          }
                      }"""

    func _init(token,identity_id):
        if typeof(token) == TYPE_DICTIONARY:
            var missing_vals = []
            for key in token.keys():
                if str(token[key]) == "" or token[key] == null:
                    missing_vals.append(key)

            if missing_vals.size() >= 1:
                var map = {"value":"Number To Mint"}

                error = "Please complete the following :"
                var sep = " "
                for e in missing_vals:
                    error += sep + map[e]
                    sep = " / "
        else:
            error = "Invalid Argument type"

        var body = {}
        body["query"] = set_query(token,identity_id)
        query = to_json(body)

class MeltEnjinTokenRequest:
    var query setget ,get_query
    var error setget ,get_error

    func get_query():
        return query

    func get_error():
        return error

    func set_query(token,identity_id):
        return """mutation {
                      CreateEnjinRequest(identity_id:"""+str(identity_id)+""",type:MELT,
                                         melt_token_data:{token_id:\""""+token["token_id"]+"""\",
                                                          token_index:\""""+token["token_index"]+"""\",
                                                          value:"""+token["value"]+"""}){
                              token{
                                  token_id
                                  name
                              }
                          }
                      }"""

    func _init(token,identity_id):
        if typeof(token) == TYPE_DICTIONARY:
            var missing_vals = []
            for key in token.keys():
                if str(token[key]) == "" or token[key] == null:
                    missing_vals.append(key)

            if missing_vals.size() >= 1:
                var map = {"value": "Number to Melt"}

                error = "Please complete the following :"
                var sep = " "
                for e in missing_vals:
                    error += sep + map[e]
                    sep = " / "
        else:
            error = "Invalid Argument type"

        var body = {}
        body["query"] = set_query(token,identity_id)
        query = to_json(body)

class EnjinTokens:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(param,searchable):
        var fields = ""

        if searchable == SEARCHABLE.BYID:
            fields = "(token_id:\""+str(param)+"\")"
        elif searchable == SEARCHABLE.BYADDRESS:
            fields = "(creator:\""+str(param)+"\")"
        elif searchable == SEARCHABLE.BYNAME:
            fields = "(name:\""+str(param)+"\")"

        return """query{
                      EnjinTokens"""+fields+"""{
                          creator
                          token_id
                          index
                          name
                          totalSupply
                          reserve
                          nonFungible
                          meltValue
                          meltFeeRatio
                          transferable
                          supplyModel
                          balance
                          circulatingSupply
                          transferFeeSettings{
                              token_id
                              type
                          }
                      }
                  }"""

    func _init(param = null,searchable = SEARCHABLE.DEFAULT):
        var body = {}
        body["query"] = set_query(param,searchable)
        query = to_json(body)

class GetIdentityById:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(identity_id):
        return """query{
                      EnjinIdentities(id:"""+identity_id+"""){
                          ethereum_address
                      }
                  }"""

    func _init(identity_id):
        var body = {}
        body["query"] = set_query(str(identity_id))
        query = to_json(body)

class GetMintAllowance:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(token_id):
        return """query{
                      EnjinTokens(token_id:\""""+token_id+"""\"){
                          availableToMint
                      }
                  }"""

    func _init(token_id):
        var body = {}
        body["query"] = set_query(str(token_id))
        query = to_json(body)

class FundWallet:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(identity_id):
        return """mutation{
                      CreateEnjinRequest(identity_id:"""+identity_id+""",type:APPROVE,
                                         approve_enj_data:{value:7}){
                          id
                      }
                  }"""

    func _init(identity_id):
        var body = {}
        body["query"] = set_query(str(identity_id))
        query = to_json(body)

class CreateEnjinRole:
    var query setget ,get_query
    var error setget ,get_error

    func get_query():
        return query

    func get_error():
        return error

    func set_query(name,permissions):
        return """mutation {
                      CreateEnjinRole(name:\""""+name+"""\",permissions:"""+str(permissions)+"""){
                          id
                          name
                          permissions{
                              id
                              name
                          }
                       }
                   }"""

    func _init(name,permissions):
        if name == "":
            error = "Missing Name. Please set the new Role Name."
        elif permissions.size() == 0:
            error = "Missing Permissions. Please select the desired permissions for the new Role."

        var body = {}
        body["query"] = set_query(name,permissions)
        query = to_json(body)

class EnjinRoles:
    var query setget ,get_query

    func get_query():
        return query

    func set_query():
        var fields = ""

        return """query{
                      EnjinRoles{
                          id
                          name
                          permissions{
                              name
                          }
                      }
                  }"""

    func _init():
        var body = {}
        body["query"] = set_query()
        query = to_json(body)

class GetBalance:
    var query setget ,get_query

    func get_query():
        return query

    func set_query(indentity_id):
        var fields = ""

        return """query{
                      EnjinIdentities(id:"""+indentity_id+"""){
                          all_tokens_balance,
                          enj_balance,
                          eth_balance
                      }
                  }"""

    func _init(indentity_id):
        var body = {}
        body["query"] = set_query(str(indentity_id))
        query = to_json(body)

class CreateEnjinApp:
    var query setget ,get_query
    var error setget ,get_error

    func get_query():
        return query

    func get_error():
        return error

    func set_query(name, icon, description):
        var args = ""
        if description != "":
            args += ",description:\""+description+"\""

        if icon != "":
            args+= ",image:\""+icon+"\""

        return """mutation{
                      CreateEnjinApp(name:\""""+name+"\""+args+"""){
                          id
                          name
                          description
                          image
                          identities{
                              id
                              linking_code
                              ethereum_address
                              app{
                                  id
                                  name
                                  roles{
                                     name
                                  }
                              }
                          }
                      }
                  }"""

    func _init(name, icon = "", description = ""):
        var body = {}
        if name == "":
            error = "Name cannot be empty"

        body["query"] = set_query(name, icon, description)
        query = to_json(body)

class EditEnjinApp:
    var query setget ,get_query
    var error setget ,get_error

    func get_query():
        return query

    func get_error():
        return error

    func set_query(name, icon, description):
        var args = ""
        if description != "":
            args += ",description:\""+description+"\""

        if icon != "":
            args+= ",image:\""+icon+"\""

        return """mutation{
                      UpdateEnjinApp(name:\""""+name+"\""+args+"""){
                          id
                          name
                          description
                          image
                      }
                  }"""

    func _init(name, icon = "", description = ""):
        var body = {}
        if name == "":
            error = "Name cannot be empty"

        body["query"] = set_query(name, icon, description)
        query = to_json(body)

func _ready():
    pass