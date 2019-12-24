extends Container

func update_hud(player):
    $CoinDisplay/CoinCount.text = str(player.coins)
    $HealthBar/Progress.value = player.health
