extends Container

func update_hud(player):
    $CoinCount.text = str(player.coins)
