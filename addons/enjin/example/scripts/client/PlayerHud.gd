extends Container

func update_hud(player):
    print("hude update")
    $HBoxContainer/Coins/Amount.text = str(player.coins)
    $Health/ProgressBar.value = player.health


func key_grabbed(body):
    $HBoxContainer/Key.show()
