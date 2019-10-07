extends "res://addons/enjin/legacy/graphql.gd"

var helper
var enjin_api
var enjinObj

var references

class NodesReferences:
    var popup
    var nodes = {}

    func _init(_popup):
        popup = _popup
        nodes["eth.address"] = popup.get_node("tabs/Wallet/p/linked_mode/eth_address/val")
        nodes["mint.eth.address"] = popup.get_node("tabs/Cryptoitems/top_panel/balance_panel/wallet_address")
        nodes["mint.balance"] = popup.get_node("tabs/Cryptoitems/top_panel/balance_panel/balance/t2")
        nodes["tabs"] = popup.get_node("tabs")
        nodes["linking.code"] = popup.get_node("tabs/Wallet/p/unlinked_mode/linking_code")
        nodes["balance.enj"] = popup.get_node("tabs/Wallet/p/linked_mode/balances/enj/val")
        nodes["balance.eth"] = popup.get_node("tabs/Wallet/p/linked_mode/balances/eth/val")
        nodes["balance.tokens"] = popup.get_node("tabs/Wallet/p/linked_mode/balances/tokens/val")

var linked = false

##### WALLET PANEL SIGNALS [BTN,SIGNAL,FUNCTION_NAME]
var buttons = [["tabs/Wallet/p/unlinked_mode/link_btn","pressed","link",true],
               ["tabs/Wallet/p/linked_mode/unlink_btn","pressed","unlink",true],
               ["tabs/Wallet/p/linked_mode/balances/refresh_balance","pressed","get_balance"],
               ["tabs/Wallet/p/linked_mode/btns/download","pressed","on_download"]]

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

func node(name):
    return references.nodes[name]

func update_p(e):

    print(enjinObj.current_identity)
    match e:
        enjin_api.event.UPDATE_IDENTITY:
            link(false)
        enjin_api.event.UNLINK_IDENTITY:
            unlink(false)
        enjin_api.event.GET_BALANCE:
            node("balance.enj").text = enjinObj.balance["enj_balance"] + " ENJ"
            node("balance.eth").text = enjinObj.balance["eth_balance"] + " ETH"
            node("balance.tokens").text = enjinObj.balance["token_count"]
            node("mint.balance").text = enjinObj.balance["enj_balance"] + " ENJ"

func clear():
    self.enjinObj = enjin_api.obj
    unlink(false)

func link(refresh):
    if enjinObj.current_identity["ethereum_address"] == null:
        var id = enjinObj.current_identity["id"]

        if !refresh:
            return

        enjin_api.request(EnjinIdentities.new(id,SEARCHABLE.BYID).query,
                          self,
                          enjin_api.event.UPDATE_IDENTITY)
        return

    node("eth.address").bbcode_text = "[color=grey][u]"+enjinObj.current_identity["ethereum_address"]+"[/u][/color]"
    node("mint.eth.address").text = enjinObj.current_identity["ethereum_address"]
    helper.hide_and_show(["tabs/Wallet/p/unlinked_mode"],["tabs/Wallet/p/linked_mode"])
    linked = true

    get_balance()

    for i in range (1,node("tabs").get_child_count()):
        if node("tabs").get_tab_disabled(i):
             node("tabs").set_tab_disabled(i,false)

func fund_wallet():
    enjin_api.request(FundWallet.new(enjinObj.current_identity["id"]).query,
                      self,
                      enjin_api.event.FUND_WALLET)

func get_balance():
    enjin_api.request(GetBalance.new(enjinObj.current_identity["id"]).query,
                      self,
                      enjin_api.event.GET_BALANCE)

func on_download():
    OS.shell_open("https://enjinwallet.io/")

func unlink(update):
    if update:
        enjin_api.request(UnlinkEnjinIdentity.new(enjinObj.current_identity["id"]).query,
                                                  self,
                                                  enjin_api.event.UNLINK_IDENTITY)
        return

    linked = false
    helper.hide_and_show(["tabs/Wallet/p/linked_mode"],["tabs/Wallet/p/unlinked_mode"])

    for i in range(1,node("tabs").get_child_count() - 2):
        node("tabs").set_tab_disabled(i,true)

    if !enjinObj.current_identity:
        return

    var code = enjinObj.current_identity["linking_code"]
    node("linking.code").text = code if code != null else ""