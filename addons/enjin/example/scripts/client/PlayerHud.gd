extends Container

func update_hud(player):
    $HBoxContainer/Coins/Amount.text = str(player.coins)
    $Health/ProgressBar.value = player.health

func key_grabbed(body):
    $HBoxContainer/Key.show()
