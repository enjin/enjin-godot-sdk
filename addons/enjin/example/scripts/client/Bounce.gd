extends Area2D
signal bounced_on

func bounced_on(entity):
    emit_signal("bounced_on", entity)
