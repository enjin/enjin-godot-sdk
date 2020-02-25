extends Container

func update_hud(player):
    print("hude update")
    $Coins/Amount.text = str(player.coins)
    $Health/ProgressBar.value = player.health
