extends CanvasLayer

func _on_login_pressed():
    var email: String = $Panel/Form/EmailInput.text
    var password: String = $Panel/Form/PasswordInput.text
    var callback = EnjinCallback.new(self, "_on_login_response")
    Enjin.client.login_user(email, password, callback);

func _on_login_response(res_body):
    print("Login Result:\n%s" % str(res_body))
