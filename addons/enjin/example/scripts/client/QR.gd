extends Popup
signal wallet_linked

func _wallet_linked():
    hide()
    emit_signal("wallet_linked")
