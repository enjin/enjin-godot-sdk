extends CanvasLayer

export(NodePath) var form

func _ready():
    hide_errors()

func _on_login_pressed():
    hide_errors()

    var email: String = email_input().text
    var password: String = password_input().text

    var valid = true
    if email.empty():
        show(email_error())
        valid = false
    if password.empty():
        show(password_error())
        valid = false

    if !valid:
        return

    var callback = EnjinCallback.new(self, "_on_login_response")
    Enjin.client.login_user(email, password, callback);

func _on_login_response(response: EnjinResponse):
    print("Code: %s" % response.get_code())
    print("Headers: %s" % response.get_headers())
    print("Body: %s" % response.get_body())

func show(control: Control):
    control.set_visible_characters(-1)

func hide_errors():
    email_error().set_visible_characters(0)
    password_error().set_visible_characters(0)

func get_form() -> Node:
    return get_node(form)

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