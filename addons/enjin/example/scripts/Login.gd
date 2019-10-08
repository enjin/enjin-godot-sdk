extends CanvasLayer

func _on_login_pressed():
    var email: String = $Panel/Form/EmailInput.text
    var password: String = $Panel/Form/PasswordInput.text
    Enjin.client.login_user(email, password);
