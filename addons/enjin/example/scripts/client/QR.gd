extends Popup
signal wallet_linked

func _wallet_linked():
    hide()
    get_tree().paused = false
    emit_signal("wallet_linked")
