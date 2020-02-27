extends Container

var player

func _ready():
    player = get_tree().get_nodes_in_group("player")[0]

func _process(delta):
    $Health/ProgressBar.max_value = player.max_health
    $Health/ProgressBar.value = player.health
    $HBoxContainer/Coins/Amount.text = str(player.coins + player.coins_in_wallet)

func key_grabbed(body):
    $HBoxContainer/Key.show()
