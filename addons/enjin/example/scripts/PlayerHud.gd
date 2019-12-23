extends Container

func update_hud(player):
    $CoinDisplay/CoinCount.text = str(player.coins)
    $HealthDisplay/Scaler/Progress.value = player.health
