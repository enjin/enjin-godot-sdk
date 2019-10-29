extends "res://addons/enjin/example/scripts/Login.gd"

func _ready():
    #Makes it easier for gut tests to find credentials
    email_input().add_to_group("email_input")
    password_input().add_to_group("password_input")
    get_parent().get_node("Gut").set_should_maximize(true)

func _on_login_response(udata: Dictionary):
    print("on_login_response")

func _on_login_pressed():
    print("on_login_pressed")
    get_parent().get_node("Gut")._test_the_scripts()
