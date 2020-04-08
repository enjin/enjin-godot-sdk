extends PopupPanel

const LOSS_TITLE_TEXT: String = "YOU DIED!"
const LOSS_SUBTITLE_TEXT: String = ""
const WIN_TITLE_TEXT: String = "CONGRATULATIONS!"
const WIN_SUBTITLE_TEXT: String = "Tokens have been sent to your wallet"

var _player

func _ready():
    _player = get_tree().get_nodes_in_group("player")[0]

func show():
    .show()
    
    var title: String
    var subtitle: String
    
    if _player.is_dead():
        title = LOSS_TITLE_TEXT
        subtitle = LOSS_SUBTITLE_TEXT
    else:
        title = WIN_TITLE_TEXT
        subtitle = WIN_SUBTITLE_TEXT
    
    $Center/VBox/Labels/Title.text = title
    $Center/VBox/Labels/Label.text = subtitle
    
    $Center/VBox/Button.grab_focus()
    $Center/VBox/Button.grab_click_focus()

func _on_btn_mouse_entered():
    $HighlightSFX.play(0)

func _on_btn_pressed():
    $PressedSFX.play(0)
