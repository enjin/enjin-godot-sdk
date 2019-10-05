tool
extends EditorPlugin

var enjin_tscn = preload("res://addons/enjin/enjin.tscn")
var enjin

class Panels:
    var home
    var team
    var identities
    var tokens
    var wallet
    var settings

    func _init(_home,_team,_identities,_tokens,_wallet,_settings):
        home = _home
        team = _team
        identities = _identities
        tokens = _tokens
        wallet = _wallet
        settings = _settings

var panels
var helper
var enjin_api

func _enter_tree():
    # Initialization of the plugin goes here
    enjin = enjin_tscn.instance()
    var popup = enjin.get_node("popup")

    helper = load("res://addons/enjin/helpers/plugin_helper.gd").new(enjin,self)
    enjin_api = load("res://addons/enjin/enjin_api.gd").new(helper)
    add_control_to_container(CONTAINER_TOOLBAR,enjin)

    panels = Panels.new(load("res://addons/enjin/panels/home_panel.gd").new(enjin, self),
                        load("res://addons/enjin/panels/team_panel.gd").new(enjin, self),
                        load("res://addons/enjin/panels/identities_panel.gd").new(enjin, self),
                        load("res://addons/enjin/panels/tokens_panel.gd").new(enjin, self),
                        load("res://addons/enjin/panels/wallet_panel.gd").new(enjin, self),
                        load("res://addons/enjin/panels/settings_panel.gd").new(enjin, self))

    enjin.get_node("enjin_btn").connect("pressed",self,"start_enjin")
    enjin.get_node("enjin_btn").rect_global_position = Vector2(-OS.get_screen_size().x * 0.77,5)

    popup.rect_global_position = Vector2(OS.get_screen_size().x * 0.20,OS.get_screen_size().y * 0.10)

    popup.get_node("tabs").add_stylebox_override("tab_disabled",popup.get_node("tabs").get_stylebox("tab_bg"))
    for i in range(1,popup.get_node("tabs").get_child_count()):
        popup.get_node("tabs").set_tab_disabled(i,true)

func _exit_tree():
    remove_control_from_container(CONTAINER_TOOLBAR,enjin)

func start_enjin():
    enjin.get_node("popup").popup()