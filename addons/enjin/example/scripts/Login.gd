extends CanvasLayer

export(NodePath) var form

var email_regex

func _init():
    email_regex = RegEx.new()
    email_regex.compile("[^@]+@[^\\.]+\\..+")

func _ready():
    hide_errors()

func _on_login_pressed():
    if get_button().disabled:
        return

    hide_errors()

    var email: String = email_input().text
    var password: String = password_input().text

    var valid = true
    if email.empty():
        show(email_error())
        valid = false
    if !email_regex.search(email):
        show(email_error())
        valid = false
    if password.empty():
        show(password_error())
        valid = false

    if !valid:
        return

    var options = {
        "callback": EnjinCallback.new(self, "_on_login_response")
    }
    Enjin.client.auth_user(email, password, options);

    get_button().disabled = true

func _on_login_response(data: Dictionary):
    if Enjin.client.is_authed():
        get_tree().change_scene("res://addons/enjin/example/scenes/Main.tscn")
    else:
        get_button().disabled = false

func show(control: Control):
    control.set_visible_characters(-1)

func hide_errors():
    email_error().set_visible_characters(0)
    password_error().set_visible_characters(0)

func get_form() -> Node:
    return get_node(form)

func get_button() -> Button:
    return get_form().get_node("Margin").get_node("Submit") as Button

func get_input(parent: String) -> Node:
    return get_form().get_node(parent).get_node("Input")

func get_error(parent: String) -> Node:
    return get_form().get_node(parent).get_node("Error")

func email_input() -> LineEdit:
    return get_input("Email") as LineEdit

func password_input() -> LineEdit:
    return get_input("Password") as LineEdit

func email_error() -> Label:
    return get_error("Email") as Label

func password_error() -> Label:
    return get_error("Password") as Label