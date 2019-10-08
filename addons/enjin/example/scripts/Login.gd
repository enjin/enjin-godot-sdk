extends CanvasLayer

func _on_login_pressed():
    var email: String = $Panel/Form/EmailInput.text
    var password: String = $Panel/Form/PasswordInput.text
    var call = EnjinCallback.new(self, "_on_login_response")
    Enjin.client.login_user(email, password, call);

func _on_login_response(res):
    pass
