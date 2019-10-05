extends "res://addons/enjin/graphql.gd"

var roles ={"View App":"viewApp",
            "View Users":"viewUsers",
            "View Identities":"viewIdentities",
            "View Requests":"viewRequests",
            "View Events":"viewEvents",
            "View Fields":"viewFields",
            "View Tokens":"viewTokens",
            "View Roles":"viewRoles",
            "View Balances":"viewBalances",
            "Manage App":"manageApp",
            "Manage Users":"manageUsers",
            "Manage Identities":"manageIdentities",
            "Manage Requests":"manageRequests",
            "Manage Fields":"manageFields",
            "Manage Tokens":"manageTokens",
            "Manage Roles":"manageRoles",
            "Delete App":"deleteApp",
            "Delete Users":"deleteUsers",
            "Delete Identities":"deleteIdentities",
            "Delete Fields":"deleteFields",
            "Delete Tokens":"deleteTokens",
            "Delete Roles":"deleteRoles",
            "Transform Tokens":"transferTokens",
            "Melt Tokens":"meltTokens",
            "View Platform":"viewPlatform"}

var helper
var enjin_api
var enjinObj

var references

class NodesReferences:
    var popup
    var nodes = {}

    func _init(_popup):
        popup = _popup
        nodes["new.user.roles"] = popup.get_node("tabs/Team/dialog/grid/role/opt")
        nodes["new.permissions"] = popup.get_node("tabs/Settings/p/grid")   ##### SETTINGS NEW ROLE PERMISSIONS
        nodes["default.role"] = popup.get_node("tabs/Settings/p/c/d")       ##### SETTINGS DEFAULT ROLE
        nodes["permissions"] = popup.get_node("tabs/Settings/p/c/p")        ##### SETTINGS PERMISSIONS
        nodes["roles"] = popup.get_node("tabs/Settings/p/c/opt")            ##### SETTINGS AVAILABLE ROLES
        nodes["new.role.name"] = popup.get_node("tabs/Settings/p/role/val") ##### SETTINGS NEW ROLE NAME

var refresh = true ##### Refresh the default permissions

##### Settings PANEL SIGNALS [BTN,SIGNAL,FUNCTION_NAME, OPTIONAL ARG]
var buttons = [["tabs/Settings/p/btns/create","pressed","on_create_role"],
               ["tabs/Settings/p/btns/cancel","pressed","on_cancel_new_role"],
               ["tabs/Settings/p/c/new_role","pressed","on_new_role"],
               ["tabs/Settings/p/c/opt","item_selected","on_role_selected"],
               ["tabs","tab_selected","selected"]]

##### OPTIONS BUTTONS DEFAULT VALUES [BTN,VALUE]
var default_options = [["tabs/Settings/p/c/opt", "Default"]]

func _ready():
    pass

func _init(plugin, main):
    self.helper = main.helper
    self.references = NodesReferences.new(plugin.get_node("popup"))
    self.enjin_api = main.enjin_api
    self.enjinObj = main.enjin_api.obj

    for btn in buttons:
        var args = []
        if btn.size() > 3:
            args.append(btn[3])

        self.references.popup.get_node(btn[0]).connect(btn[1], self, btn[2], args)

    for btn in default_options:
        self.references.popup.get_node(btn[0]).add_item(btn[1])

    var keys = roles.keys()
    if keys.size() != node("new.permissions").get_child_count():
        print("invalid Role count !!")
        return

    for i in range(keys.size()):
        node("new.permissions").get_child(i).text = keys[i]

func node(name):
    return references.nodes[name]

func update_p(e):
    match e:
        enjin_api.event.CREATE_ROLE:
            on_cancel_new_role()
            var keys = enjinObj.roles.keys()
            node("roles").add_item(keys[keys.size() - 1])
            if !node("roles").visible:
                node("roles").show()

            node("new.user.roles").add_item(keys[keys.size() - 1])

func clear():
    self.enjinObj = enjin_api.obj

    node("default.role").bbcode_text = "[color=grey]Default Role:[/color]"
    node("permissions").bbcode_text = "[color=grey]Permissions:[/color]"
    refresh = true
    on_cancel_new_role()

    for i in range(node("roles").get_item_count()-1,0,-1):
        node("roles").remove_item(i)
    helper.hide_and_show(["tabs/Settings/p/c/opt"],[])
    node("roles").select(0)

func selected(tab):
    if tab == 5:
        if !refresh:
            return

        refresh = false

        update_permissions(enjinObj.current_user["permissions"])

        if !enjinObj.current_user["role_name"]:
            return

        var n = node("default.role")
        n.bbcode_text += " "+enjinObj.current_user["role_name"]

func update_permissions(permissions):
    if typeof(permissions) != TYPE_ARRAY:
            return

    if permissions.size() < 1:
        return

    var n = node("permissions")
    n.bbcode_text = "[color=grey]Permissions:[/color]"

    var separator = " "
    var keys = roles.keys()
    for p in permissions:
        var s = ""
        if typeof(p) == TYPE_STRING:
            var vals = roles.values()
            var idx = vals.find(p)
            if idx != -1:
                s = keys[idx]
            pass
        elif typeof(p) == TYPE_DICTIONARY:
            s = keys[p["id"] - 1]

        n.bbcode_text += "[color=green]"+separator+s+"[/color]"
        separator = " | "

func on_create_role():
    var name = node("new.role.name").text
    var permissions = []

    for p in node("new.permissions").get_children():
        if p.pressed:
            permissions.append("\""+roles[p.text]+"\"")

    var enjinRole = CreateEnjinRole.new(name,permissions)

    if enjinRole.error:
        helper.error(enjin_api.event.CREATE_ROLE,enjinRole.error,"finished_with_error")
        return

    enjin_api.request(enjinRole.query,
                      self,
                      enjin_api.event.CREATE_ROLE)

func on_new_role():
    if !enjinObj.role.has("manageRoles"):
        helper.error(enjin_api.event.CREATE_ROLE,"You do not have the necessary permissions to create Roles. Contact your Platform Admin.","finished_with_error")
        return

    helper.hide_and_show(["tabs/Settings/p/c"],["tabs/Settings/p/grid","tabs/Settings/p/role","tabs/Settings/p/btns"])

func on_role_selected(ID):
    var opt = node("roles").get_item_text(ID)
    if opt == "Default":
        update_permissions(enjinObj.current_user["permissions"])
    elif enjinObj.roles.has(opt):
        update_permissions(enjinObj.roles[opt])

func on_cancel_new_role():
    helper.hide_and_show(["tabs/Settings/p/grid","tabs/Settings/p/role","tabs/Settings/p/btns"],["tabs/Settings/p/c"])
